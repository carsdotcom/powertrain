# POWERTRAIN

Powertrain is a basic orchestration tool for Docker built atop GNU Make.

## Install

1. Clone this repo.
2. Make the `powertrain` script executable.
3. Get `powertrain` into your `$PATH` (either by adding a symlink to `./powertrain/powertrain` to an existing directory in your `$PATH` or by adding the repo directory to directory in your `$PATH`).
4. Set `$POWERTRAIN` environment variable in your `.bashrc` or `.profile` to `./powertrain/Makefile`.


## Project Setup

To get started with powertrain, add a Makefile to the root of your project directory. This should be in the same directory as you Dockerfile. Here's an example of what a powertrain Makefile file might look like:


    include /foo/powertrain/Makefile

    NAME=my-application
    VERSION=default
    SEMVER=patch
    INSTANCES=1
    REGISTRY=repository.cars.com
    SLEEP=10
    DEFAULT_PORT=1337
    RUN_SCRIPT=$(CURDIR)/scripts/docker/run.sh
    VERSION_SCRIPT=$(CURDIR)/scripts/docker/var/VERSION.sh
    BUMP_VERSION_SCRIPT=$(CURDIR)/scripts/docker/bumpVersion.sh
    VALIDATE_ENV_SCRIPT=$(CURDIR)/scripts/docker/validateEnv.sh


## Usage

Chain together the goals documented below to create simple workflows. Override variables in-line with each command or in your projects powertrain Makefile.

### Example

    powertrain validate bump-version build publish run sleep stop-old INSTANCES=4 SLEEP=30


## Goals

### Build


    powertrain build


The above command will build an image tagged with a specified name and version number. If no arguments are provided, this will build an image with the name and version specified in your project's `Makefile`, or if not specified, the default name and version `powertrain:latest`.

The defaults can be overridden by supplying `NAME` and `VERSION` variables inline with the command like so: `powertrain build NAME=my-application VERSION=1.2.3`.


<br>

### Start Container


    powertrain run


The above command will start a container tagged with a specified name and version number. If no arguments are provided, this will attempt to run an image with the name and version specified in your project's `Makefile`, or if not specified, the default name and version `powertrain:latest`.

The defaults can be overridden by supplying the `NAME` and `VERSION` variables inline with the command like so: `powertrain run NAME=my-application VERSION=1.2.3`.


<br>

### Stop Containers


    powertrain stop


The above command will stop a container tagged with a specified name and version number. If no arguments are provided, this will attempt to stop any containers with the name and version specified in your project's `Makefile`, or if not specified, the default name and version `powertrain:latest`.

The defaults can be overridden by supplying the `NAME` and `VERSION` variables inline with the command like so: `powertrain stop NAME=my-application VERSION=1.2.3`.


    powertrain stop-all


The above command will stop all containers matching the target project's name.


<br>

### Remove Containers


    powertrain rm


The above command will remove all containers tagged with a specified name and version number. If no arguments are provided, this will attempt to remove any containers with the name and version specified in your project's `Makefile`, or if not specified, the default name and version `powertrain:latest`.

The defaults can be overridden by supplying the `NAME` and `VERSION` variables inline with the command like so: `powertrain rm NAME=my-application VERSION=1.2.3`.


    powertrain rm-all


The above command will remove all containers matching the target project's name.


<br>

### Remove Images


    powertrain rmi


The above command will remove all images tagged with a specified name and version number. If no arguments are provided, this will attempt to remove any images with the name and version specified in your project's `Makefile`, or if not specified, the default name and version `powertrain:latest`.

The defaults can be overridden by supplying the `NAME` and `VERSION` variables inline with the command like so: `powertrain rmi NAME=my-application VERSION=1.2.3`.


    powertrain rmi-all


The above command will remove all images matching the target project's name.


<br>

### Publish


    powertrain publish


The above command will tag and push an image to our internal docker registry with a specified name and version number. If no arguments are provided, this will deploy an image with the name and version from the `package.json`.

The defaults can be overridden by supplying the `NAME` and `VERSION` variables inline with the command like so: `powertrain publish NAME=www-cars-com-rendering VERSION=1.2.3`

