NAME=powertrain
VERSION=default
SEMVER=patch
INSTANCES=1
REGISTRY=repository.cars.com
SLEEP=10
DEFAULT_PORT=1337
RUN_SCRIPT=default
VERSION_SCRIPT=default
BUMP_VERSION_SCRIPT=default
VALIDATE_ENV_SCRIPT=default
MACHINE_NAME=cars
MACHINE_ALIAS=dockerhost
MACHINE_PORT=2376

help:
	@echo "Please provide one or more goals..."

run:
	$(POWERTRAIN_DIR)/scripts/run.sh  $(NAME) $(VERSION) $(REGISTRY) $(INSTANCES) $(DEFAULT_PORT) $(RUN_SCRIPT) $(VERSION_SCRIPT)

build:
	$(POWERTRAIN_DIR)/scripts/build.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT) $(PROJECT_DIR)

tag:
	$(POWERTRAIN_DIR)/scripts/tag.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

push:
	$(POWERTRAIN_DIR)/scripts/push.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

pull:
	$(POWERTRAIN_DIR)/scripts/pull.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

publish: tag push

stop:
	$(POWERTRAIN_DIR)/scripts/stop.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

stop-all:
	$(MAKE) stop VERSION=all

stop-old:
	$(POWERTRAIN_DIR)/scripts/stopOld.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

kill:
	$(POWERTRAIN_DIR)/scripts/kill.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

kill-all:
	$(MAKE) kill VERSION=all

kill-old:
	$(POWERTRAIN_DIR)/scripts/killOld.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

rm:
	$(POWERTRAIN_DIR)/scripts/rm.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

rm-all:
	$(MAKE) rm VERSION=all

rm-old:
	$(POWERTRAIN_DIR)/scripts/rmOld.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

rmi:
	$(POWERTRAIN_DIR)/scripts/rmi.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

rmi-all:
	make rmi VERSION=all

rmi-old:
	$(POWERTRAIN_DIR)/scripts/rmiOld.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

sleep:
	@sleep $(SLEEP)

bump-version:
	$(POWERTRAIN_DIR)/scripts/bumpVersion.sh $(SEMVER) $(BUMP_VERSION_SCRIPT)

validate-env:
	$(POWERTRAIN_DIR)/scripts/validateEnv.sh $(VALIDATE_ENV_SCRIPT)

docker-clean:
	$(POWERTRAIN_DIR)/scripts/dockerCleanUp.sh

machine-route: 
	$(POWERTRAIN_DIR)/scripts/machineRoute.sh

machine-do-create:
	$(POWERTRAIN_DIR)/scripts/machineCreate.sh $(MACHINE_NAME)

machine-start:
	$(POWERTRAIN_DIR)/scripts/machineStart.sh $(MACHINE_NAME)

machine-stop:
	$(POWERTRAIN_DIR)/scripts/machineStop.sh $(MACHINE_NAME)

machine-env:
	$(POWERTRAIN_DIR)/scripts/machineEnv.sh $(MACHINE_NAME)

machine-modify-port:
	$(POWERTRAIN_DIR)/scripts/machinePort.sh $(MACHINE_NAME) $(MACHINE_ALIAS) $(MACHINE_PORT)

machine-port: machine-stop machine-modify-port machine-start

machine-create: machine-do-create machine-port 

machine: machine-route machine-start machine-env

deploy: pull run sleep stop-old

.PHONY: help
.PHONY: build
.PHONY: run
.PHONY: tag
.PHONY: push
.PHONY: pull
.PHONY: publish
.PHONY: stop
.PHONY: stop-all
.PHONY: stop-old
.PHONY: rm
.PHONY: rm-all
.PHONY: rm-old
.PHONY: rmi
.PHONY: rmi-all
.PHONY: rmi-old
.PHONY: sleep
.PHONY: bump-version
.PHONY: validate-env
.PHONY: release
.PHONY: deploy
.PHONY: docker-clean
.PHONY: machine-route
.PHONY: machine-create
.PHONY: machine-start
.PHONY: machine-stop
.PHONY: machine-env
.PHONY: machine-modify-port
.PHONY: machine-port
.PHONY: machine
