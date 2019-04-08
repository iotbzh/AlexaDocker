#!/bin/bash

set -e
set -x

CLIENT_ID=amzn1.application-oa2-client.7724d6dd35ab46d38cd11beae55c1245
PRODUCT_NAME=AGL_master
SERIAL_NUMBER=123456789
SOUND_CARD=HD

ALEXA_CONFIG=/workdir/aac-sdk/platforms/agl/alexa-voiceagent-service/src/plugins/data/config/AlexaAutoCoreEngineConfig.json

sed -i -e "s/\"clientId\":.*/\"clientId\":\"$CLIENT_ID\",/g" \
       -e "s/\"deviceSerialNumber\":.*/\"deviceSerialNumber\":\"$SERIAL_NUMBER\",/g" \
       -e "s/\"productId\":.*/\"productId\":\"$PRODUCT_NAME\"/g" \
       -e "s/\"speechRecognizer\":.*/\"speechRecognizer\":\"hw:$SOUND_CARD\",/g" \
       $ALEXA_CONFIG


