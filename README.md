# Alexa build docker

## Build the AAC SDK

```
mkdir -p ~/workdir
git clone https://github.com/iotbzh/AlexaDocker.git
cd AlexaDocker
```

### Proprietary wake word engine (amazonlite)

The usage of amazonlite is optional, and depends on the value **HAVE_AMAZONLITE** in the *build.conf* file.
When setting **HAVE_AMAZONLITE** to **Y**, you must either have a copy of snapshot of the amazonlite package
under the *AlexaDocker* directory, or an SSH access to the private code.iot.bzh/amazonlite repository.

When setting **HAVE_AMAZONLITE** to **N**, the voice agent will be built without wake word support.

### Customize the product IDs and sound card

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
./build.bash
```

That will take quite a long time (~25 minutes)


## Build the voice agent

Launch the container:

```
./run.bash
```

In the container; launch:

```
./build_voice_agent.bash
```

Exit the container.

The generated widget is at:

*~/workdir/voice_agent_build/alexa-voiceagent-service-debug.wgt*

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

