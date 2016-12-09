#!/bin/bash
get_keys() {
  local key=$2 data=$1 result=""
  if echo $data | jq -e 'has('\""$key"\"')' > /dev/null; then
    result=$(echo "$data" | jq -r '.'"$key"'|keys[]')
  fi
  echo $result
}

get_values() {
  local key=$2 data=$1 query=$3 result=""
  if echo $data | jq -e 'has('\""$key"\"')' > /dev/null; then
    result=$(echo "$data" | jq -r '.'"$key"'[]|'"$query"'')
  fi
  echo $result
}

array_contains() {
  local array="$1[@]" element=$2 result=1
  for i in "${!array}"; do
    if [[ $i == $element ]]; then
      result=0
      break;
    fi
  done
  return $result
}

if ! type jq > /dev/null; then
  echo "Powertrain requires 'jq' to deploy docker services. Aborting"
  exit 1
fi
if [ -n "$1" ]; then
  # Service definition
  SERVICE=$(docker service inspect "$1" | jq .[0])

  # Various specs
  SPEC=$(echo "$SERVICE" | jq .Spec)
  CONTAINER_SPEC=$(echo "$SPEC" | jq .TaskTemplate.ContainerSpec)
  ENDPOINT_SPECT=$(echo "$SPEC" | jq .EndpointSpec)
  
  PLACEMENTS=$(echo "$SPEC" | jq .TaskTemplate.Placement)

  # Existing options in array variables
  E_SRV_LABELS=($(get_keys "$SPEC" 'Labels'))
  E_CONTAINER_LABELS=($(get_keys "$CONTAINER_SPEC" 'Labels'))
  E_ENVS=($(get_values "$CONTAINER_SPEC" 'Env' 'split("=")[0]'))
  E_CONTSTRAINTS=($(get_values "$PLACEMENTS" 'Constraints' 'split("=")[0]'))
  # For mounts, just read the mount 'Target' 
  E_MOUNTS=($(get_values "$CONTAINER_SPEC" 'Mounts' '{Target}[]'))
  # For Ports, read the TargetPort since a port can only be removed by its TargetPort 
  E_PORTS=($(get_values "$ENDPOINT_SPECT" 'Ports' '{TargetPort}[]'))

  echo "Existing Spec : "
  echo "Labels : " "${E_SRV_LABELS[@]}"  
  echo "Container Labels : " "${E_CONTAINER_LABELS[@]}"  
  echo "Envs : " "${E_ENVS[@]}"  
  echo "Constraints : " "${E_CONTSTRAINTS[@]}"  
  echo "Mounts : " "${E_MOUNTS[@]}"  
  echo "Ports : " "${E_PORTS[@]}"  
else
  echo 'No service name specified'
  exit 1
fi