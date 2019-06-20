#!/bin/bash

set -x

./fetch_amazonlite.bash

docker build --network=host --build-arg=uid=$(id -u) -t alexa .
