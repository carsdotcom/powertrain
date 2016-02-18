# POWERTRAIN

Powertrain is a basic build and deploy tool for Docker built atop GNU Make.

PLEASE NOTE: This project is in a very early stage and current only supports the specific use cases we've had so far. Support for more uses cases is under development.

## Install

1. Clone this repo.
2. Make the `powertrain` script executable.
3. Get `powertrain` into your `$PATH` (either by adding a symlink to `./powertrain/powertrain` to an existing directory in your `$PATH` or by adding the repo directory to directory in your `$PATH`).


## Project Setup

To get started with powertrain, add a Makefile to the root of your project directory. This should be in the same directory as you Dockerfile. Here's an example of what a powertrain Makefile file might look like:


    include $(POWERTRAIN)

    NAME=my-application
    VERSION=default
    SEMVER=patch
    INSTANCES=1
    REGISTRY=repository.cars.com
    SLEEP=10
    DEFAULT_PORT=1337
    RUN_SCRIPT=$(CURDIR)/scripts/docker/run.sh
    VERSION_SCRIPT=$(CURDIR)/scripts/docker/var/VERSION.sh


## Usage

Chain together the "targets" ([more on GNU Make Targets here](http://www.gnu.org/software/make/manual/make.html#Phony-Targets)) documented below to create simple workflows. Override variables in-line with each command or in your projects powertrain Makefile.

### Basic Example

    powertrain build run INSTANCES=4

### Long-Chain Example

    powertrain validate-env bump-version build tag push run sleep stop-old INSTANCES=4 SLEEP=30


## Targets

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


The above command will tag and push an image to our internal docker registry with a specified name and version number. If no arguments are provided, this will deploy an image with the name from the project's Makefile and the current git commit hash (assuming your project is using git for version control).

The defaults can be overridden by supplying the `NAME` and `VERSION` variables inline with the command like so: `powertrain publish NAME=my-application VERSION=1.2.3`

<br>

### Deploy


    powertrain deploy


The above command will pull an image from your docker registry and then execute a rolling restart of your containers. `deploy` is a composite target that execute the following targets: `pull run sleep stop-old`.

The defaults can be overridden by supplying the `NAME` and `VERSION` variables inline with the command like so: `powertrain deploy NAME=my-application VERSION=1.2.3`

<br>

### Machine Commands


    powertrain machine-create

This command will create a new machine with the default name of cars.  It will also setup port forwarding on the machine so that it can be used on and off the vpn.

<br>

    powertrain machine

This command will help set up docker properly when switching to and from the VPN.  After the command executes it will provide the eval command that will be needed for configuring the Docker global variables.

<br>
    
    powertrain machine-port MACHINE_ALIAS={alias} MACHINE_PORT={port}

When on the VPN it is necessary to set up port forwarding so that when you need to access a port on Docker container it can be routed properly.  To create a new Port Forward using this command specifying a unique name for the rule ALIAS and the PORT number.

<br>

### Machine Workflow
    powertrain machine-create # One time deal
    powertrain machine # Anytime switching on/off VPN. this will also provide the eval statement for setting up docker env variables
    powertrain machine-port #Anytime needing a port opened





