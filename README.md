# Alexa build docker

## Build the AAC SDK

```
mkdir -p ~/workdir
git clone https://github.com/iotbzh/AlexaDocker.git
cd AlexaDocker
```

Edit the *customize.bash* script to set the 
* CLIENT_ID
* PRODUCT_NAME
* SERIAL_NUMBER 
* SOUND_CARD

SOUND_CARD is the Alsa PCM device name for the voice capture.
It can be listed with:
```
arecord -l
```

Then, launch the build:

```
docker build --network=host --build-arg=uid=$(id -u) -t alexa .
```

That will take quite a long time (~25 minutes)


## Build the voice agent

Lanuch the container:

```
docker run -it  --network=host --tmpfs /tmp  -e DISPLAY=$DISPLAY --security-opt=label:type:spc_t --user=$(id -u):$(id -g) -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -v $HOME/workdir:/workdir  --rm alexa
```

In the container; launch:

```
./build_voice_agent.bash
```

The generated widget is at:

*/workdir/voice_agent_build*

Copy the widget on the target machine on /tmp.

## Install and Run the Voice Agent

On the target:
```
afm-install install afm-install install /tmp/alexa-voiceagent-service-debug.wgt 
systemctl daemon-reload
systemctl restart afm-service-alexa-voiceagent-service--0.1--main@0.service
```

Then, check the system logs:
```
journalctl  -u afm-service-alexa-voiceagent-service--0.1--main@0.service
```
and get the port number of the service:

For instance,
 "port": 31031,

On the host, open a browser on the connection app:

```
firefox ~/workdir/aac-sdk/platforms/agl/alexa-voiceagent-service/htdocs/index.html
```

Enter the targetIP:portNumber, hit enter, click on "Subscribe to CBL Events"

Get the URL (ie, https://amazon.com/us/code) and product code in the event payload.
Open a browser on that URL, enter the product code, and that's it.

## Manually start the listening

To ask Alexa to start listening, issue this on the target:
```
afb-client-demo --human 'localhost:31031/api?token=HELLO&uuid=magic' alexa-voiceagent startListening
```

