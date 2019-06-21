#!/bin/bash

# Will check if there is an existing amazonlite directory
# If not , attempt to clone it.
# If yes, issue a pull if it is a git repo

if [ ! -d amazonlite ]; then
    echo "Cloning amazonlite ..."
    git clone git@code.iot.bzh:Amazon/amazonlite.git
else
    if [ -d amazonlite/.git ]; then
        echo "Updating amazonlite ..."
        cd amazonlite && git pull
    fi
fi




