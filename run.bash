#!/bin/bash

WORKDIR=${1:-~/workdir}

mkdir -p ${WORKDIR}
docker run -it  --network=host --tmpfs /tmp  -e DISPLAY=$DISPLAY --security-opt=label:type:spc_t --user=$(id -u):$(id -g) -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -v ${WORKDIR}:/workdir  --rm alexa
