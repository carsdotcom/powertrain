#!/bin/bash
docker run --rm -it -v /etc/resolv.conf:/etc/resolv.conf -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/bin/docker powertrain:latest "$@"
