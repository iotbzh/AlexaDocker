#!/bin/bash

set -x

. build.conf

if [ x"$(echo $HAVE_AMAZONLITE | tr '[A-Z]' '[a-z]')" == xy ]; then
    ./fetch_amazonlite.bash
    AMAZONLITE_section='\
ARG AMAZONLITE=${AAC_SDK_HOME}/extras/amazonlite\
COPY amazonlite ${AMAZONLITE}'
else
    AMAZONLITE_section='RUN mkdir -p ${AMAZONLITE}'
fi

# Generate dockerfile

sed -e "s|%AMAZONLITE%|$AMAZONLITE_section|g" < Dockerfile.in > Dockerfile

docker build --network=host --build-arg=uid=$(id -u) -t alexa .
