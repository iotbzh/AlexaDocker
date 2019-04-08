#!/bin/bash

set -x
set -e

if [ x${AAC_INSTALL_ROOT} == x ]; then
	echo "Error, AAC_INSTALL_ROOT must be defined"
	exit -1
fi

voice_agent_src=/workdir/aac-sdk/platforms/agl/alexa-voiceagent-service

if [ ! -d $voice_agent_src ]; then
	cd /workdir && git clone --recursive ${AAC_REMOTE}
fi

/home/user/customize.bash

voice_agent_build=/workdir/voice_agent_build

. /opt/agl-sdk/${AGL_SDK_VERSION}+snapshot-${AGL_SDK_ARCH}/environment-setup-${AGL_SDK_ARCH}-agl-linux 
mkdir -p $voice_agent_build
cd $voice_agent_build 
cmake $voice_agent_src -DAAC_HOME=${AAC_INSTALL_ROOT} -DCMAKE_BUILD_TYPE=Debug
make widget -j
