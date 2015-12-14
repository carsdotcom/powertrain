NAME=powertrain
VERSION=default
SEMVER=patch
INSTANCES=1
REGISTRY=repository.cars.com
SLEEP=10
DEFAULT_PORT=1337
RUN_SCRIPT=default
VERSION_SCRIPT=default
BUMP_SCRIPT=default
VALIDATE_SCRIPT=default

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
	make stop VERSION=all

stop-old:
	$(POWERTRAIN_DIR)/scripts/stopOld.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

rm:
	$(POWERTRAIN_DIR)/scripts/rm.sh $(NAME) $(VERSION) $(REGISTRY) $(VERSION_SCRIPT)

rm-all:
	make rm VERSION=all

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
	$(POWERTRAIN_DIR)/scripts/bumpVersion.sh $(SEMVER) $(BUMP_SCRIPT)

validate:
	$(POWERTRAIN_DIR)/scripts/validate.sh $(VALIDATE_SCRIPT)

release: validate bump-version build publish

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
.PHONY: validate
.PHONY: release
.PHONY: deploy
