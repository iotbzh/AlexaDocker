#!/bin/bash

echo "Checking ssh access to code.iot.bzh"

ssh git@code.iot.bzh
if [ $? -eq 0 ]; then
    echo "Access OK";
else
    echo "Failed, Voice Agent will be built without amazonlite support";
    # Create empty directory for simplifying the docker creation
    mkdir amazonlite && touch amazonlite/.empty
    return 0;
fi;

if [ -d amazonlite/.git ]; then
    echo "Updating amazonlite ..."
    cd amazonlite && git pull
else
    echo "Cloning amazonlite ..."
    git clone git@code.iot.bzh:Amazon/amazonlite.git
fi



