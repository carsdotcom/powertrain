---
04/14/2017 - Bruce Zawadzki

## New Project Setup

RUN_MODE=foreground # Use to change run mode [foreground|interactive|detached (default)]
ENTRY_POINT=bash # Use to override the entrypoint


<br>

### Attach to Running Container


    powertrain attach


The above command will attached to the most recently executed and still running container.

<br>

### Attach to Running Container in Interactive Mode


    powertrain exec


The above command will attached to the most recently executed and still running container in interactive mode for debugging purposes.

<br>

### View Container Logs


    powertrain logs


The above command will show the logs from the most recently executed container.

<br>

### View Container Status


    powertrain status


The above command will show the exit code from the most recently executed container.

<br>

### View Container Exit Code


    powertrain exit-code


The above command will show the exit code from the most recently executed container.

---
