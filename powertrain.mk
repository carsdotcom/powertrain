include $(POWERTRAIN_DIR)/defaults.mk

.PHONY: help
help:
	@echo "Please provide one or more targets...\n"

.PHONY: service-rm
service-rm:
	$(POWERTRAIN_DIR)/scripts/serviceStop.sh $(NAME)

.PHONY: service-deploy
service-deploy:
	$(POWERTRAIN_DIR)/scripts/service.sh $(NAME) $(VERSION) $(REGISTRY) $(INSTANCES) $(PUBLISHED_PORTS) $(ENVS) $(LABELS) $(UPDATE_DELAY) $(PARALLEL_UPDATES) $(CONSTRAINTS) $(NETWORKS) $(SERVICE_MODE) $(LIMIT_CPU) $(LIMIT_MEM) $(RESERVE_CPU) $(RESERVE_MEM) $(MOUNTS) $(LOG_DRIVER) $(LOG_OPTS) $(CONTAINER_LABELS) $(UPDATE_FAILURE_ACTION) $(USR) $(WORK_DIR)

.PHONY: run
run:
	$(POWERTRAIN_DIR)/scripts/run.sh $(NAME) $(VERSION) $(REGISTRY) $(INSTANCES) $(NET) $(RESTART) $(EXPOSE) $(PORTS) $(VOLUMES) $(ENVS) $(LABELS) $(LOG_DRIVER) $(LOG_OPTS) $(HOSTS) $(RUN_SCRIPT) $(VERSION_SCRIPT) 

.PHONY: extract
extract:
	$(POWERTRAIN_DIR)/scripts/extract.sh $(NAME) $(VERSION) $(REGISTRY) $(INSTANCES) $(EXTRACT_ROOT) $(EXTRACT_SRC) $(EXTRACT_DEST) $(EXTRACT_CONFIG) $(VERSION_SCRIPT)

.PHONY: extract-config
extract-config:
	$(MAKE) extract NAME=$(NAME) VERSION=$(VERSION) REGISTRY=$(REGISTRY) INSTANCES=$(INSTANCES) EXTRACT_ROOT=$(EXTRACT_ROOT) EXTRACT_SRC=$(EXTRACT_SRC) EXTRACT_DEST=$(EXTRACT_DEST) EXTRACT_CONFIG=1 VERSION_SCRIPT=$(VERSION_SCRIPT)

.PHONY: do-build
do-build:
	$(POWERTRAIN_DIR)/scripts/build.sh $(NAME) $(VERSION) $(REGISTRY) $(DOCKERFILE) $(VERSION_SCRIPT) $(PT_CONTEXT)

.PHONY: pre-build
pre-build:
	$(POWERTRAIN_DIR)/scripts/preBuild.sh $(PRE_BUILD_SCRIPT)

.PHONY: post-build
post-build:
	$(POWERTRAIN_DIR)/scripts/postBuild.sh $(POST_BUILD_SCRIPT)

.PHONY: build
build: pre-build do-build post-build

.PHONY: tag
tag:
	$(POWERTRAIN_DIR)/scripts/tag.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT) $(TAG_NAME) $(TAG_VERSION) $(TAG_REGISTRY)

.PHONY: push
push:
	$(POWERTRAIN_DIR)/scripts/push.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT) $(TAG_NAME) $(TAG_VERSION) $(TAG_REGISTRY)

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
	$(POWERTRAIN_DIR)/scripts/stopOld.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT) $(INSTANCES) $(LABELS)

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
	$(MAKE) rmi VERSION=all

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

.PHONY: rm-exited
rm-exited:
	$(POWERTRAIN_DIR)/scripts/rmExited.sh $(NAME) $(REGISTRY)

.PHONY: rmi-dangling
rmi-dangling:
	$(POWERTRAIN_DIR)/scripts/rmiDangling.sh $(NAME) $(REGISTRY)

.PHONY: clean
clean: rm-exited rmi-dangling

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

.PHONY: clean-all
clean-all:
	$(POWERTRAIN_DIR)/scripts/cleanUp.sh

