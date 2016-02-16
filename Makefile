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

.PHONY: help
help:
	@echo "Please provide one or more goals...\n"

.PHONY: run
run:
	$(POWERTRAIN_DIR)/scripts/run.sh  $(NAME) $(VERSION) $(REGISTRY) $(INSTANCES) $(DEFAULT_PORT) $(RUN_SCRIPT) $(VERSION_SCRIPT)

.PHONY: build
build:
	$(POWERTRAIN_DIR)/scripts/build.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT) $(PROJECT_DIR)

.PHONY: tag
tag:
	$(POWERTRAIN_DIR)/scripts/tag.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

.PHONY: push
push:
	$(POWERTRAIN_DIR)/scripts/push.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

.PHONY: pull
pull:
	$(POWERTRAIN_DIR)/scripts/pull.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

.PHONY: publish
publish: tag push

.PHONY: ps
ps:
	$(POWERTRAIN_DIR)/scripts/ps.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

.PHONY: ps-all
ps-all:
	$(MAKE) ps VERSION=all

.PHONY: images
images:
	$(POWERTRAIN_DIR)/scripts/images.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

.PHONY: images-all
images-all:
	$(MAKE) images VERSION=all

.PHONY: stop
stop:
	$(POWERTRAIN_DIR)/scripts/stop.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

.PHONY: stop-all
stop-all:
	$(MAKE) stop VERSION=all

.PHONY: stop-old
stop-old:
	$(POWERTRAIN_DIR)/scripts/stopOld.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT) $(INSTANCES)

.PHONY: stop-other
stop-other:
	$(POWERTRAIN_DIR)/scripts/stopOther.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

.PHONY: kill
kill:
	$(POWERTRAIN_DIR)/scripts/kill.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

.PHONY: kill-all
kill-all:
	$(MAKE) kill VERSION=all

.PHONY: kill-old
kill-old:
	$(POWERTRAIN_DIR)/scripts/killOld.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

.PHONY: kill-other
kill-other:
	$(POWERTRAIN_DIR)/scripts/killOther.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

.PHONY: rm
rm:
	$(POWERTRAIN_DIR)/scripts/rm.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

.PHONY: rm-all
rm-all:
	$(MAKE) rm VERSION=all

.PHONY: rm-other
rm-other:
	$(POWERTRAIN_DIR)/scripts/rmOther.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

.PHONY: rmi
rmi:
	$(POWERTRAIN_DIR)/scripts/rmi.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

.PHONY: rmi-all
rmi-all:
	make rmi VERSION=all

.PHONY: rmi-other
rmi-other:
	$(POWERTRAIN_DIR)/scripts/rmiOther.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

.PHONY: sleep
sleep:
	@sleep $(SLEEP)

.PHONY: bump-version
bump-version:
	$(POWERTRAIN_DIR)/scripts/bumpVersion.sh $(SEMVER) $(BUMP_VERSION_SCRIPT)

.PHONY: validate-env
validate-env:
	$(POWERTRAIN_DIR)/scripts/validateEnv.sh $(VALIDATE_ENV_SCRIPT)

.PHONY: docker-clean
docker-clean:
	$(POWERTRAIN_DIR)/scripts/dockerCleanUp.sh

.PHONY: machine-route
machine-route: 
	$(POWERTRAIN_DIR)/scripts/machineRoute.sh

.PHONY: machine-do-create
machine-do-create:
	$(POWERTRAIN_DIR)/scripts/machineCreate.sh $(MACHINE_NAME)

.PHONY: machine-start
machine-start:
	$(POWERTRAIN_DIR)/scripts/machineStart.sh $(MACHINE_NAME)

.PHONY: machine-stop
machine-stop:
	$(POWERTRAIN_DIR)/scripts/machineStop.sh $(MACHINE_NAME)

.PHONY: machine-env
machine-env:
	$(POWERTRAIN_DIR)/scripts/machineEnv.sh $(MACHINE_NAME)

.PHONY: machine-modify-port
machine-modify-port:
	$(POWERTRAIN_DIR)/scripts/machinePort.sh $(MACHINE_NAME) $(MACHINE_ALIAS) $(MACHINE_PORT)

.PHONY: machine-port
machine-port: machine-stop machine-modify-port machine-start

.PHONY: machine-create
machine-create: machine-do-create machine-port 

.PHONY: machine
machine: machine-route machine-start machine-env

.PHONY: deploy
deploy: pull run sleep stop-old
