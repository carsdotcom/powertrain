ifndef VOLUMES
	VOLUMES=default
endif
ifndef NAME
	NAME=powertrain
endif
ifndef VERSION
	VERSION=default
endif
ifndef REGISTRY
	REGISTRY=default
endif
ifndef SEMVER
	SEMVER=patch
endif
ifndef INSTANCES
	INSTANCES=1
endif
ifndef SLEEP
	SLEEP=10
endif
ifndef RESTART
	RESTART=default
endif
ifndef DEFAULT_PORT
	DEFAULT_PORT=default # leaving this for backwards compatibility, do not use
endif
ifndef PORTS
	PORTS=$(DEFAULT_PORT)
endif
ifndef VOLUMES
	VOLUMES=default
endif
ifndef ENVS
	ENVS=default
endif
ifndef LABELS
	LABELS=default
endif
ifndef PRE_BUILD_SCRIPT
	PRE_BUILD_SCRIPT=default
endif
ifndef POST_BUILD_SCRIPT
	POST_BUILD_SCRIPT=default
endif
ifndef EXTRACT_ROOT
	EXTRACT_ROOT=default
endif
ifndef EXTRACT_SRC
	EXTRACT_SRC=default
endif
ifndef EXTRACT_DEST
	EXTRACT_DEST=default
endif
ifndef RUN_SCRIPT
	RUN_SCRIPT=default
endif
ifndef VERSION_SCRIPT
	VERSION_SCRIPT=default
endif
ifndef BUMP_VERSION_SCRIPT
	BUMP_VERSION_SCRIPT=default
endif
ifndef VALIDATE_ENV_SCRIPT
	VALIDATE_ENV_SCRIPT=default
endif
ifndef MACHINE_NAME
	MACHINE_NAME=powertrain
endif
ifndef MACHINE_ALIAS
	MACHINE_ALIAS=dockerhost
endif
ifndef MACHINE_PORT
	MACHINE_PORT=2376
endif
ifndef TAG_REGISTRY
	TAG_REGISTRY=default
endif
ifndef TAG_NAME
	TAG_NAME=default
endif
ifndef TAG_VERSION
	TAG_VERSION=default
endif