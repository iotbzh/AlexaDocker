FROM ubuntu:16.04

RUN apt-get update

RUN apt-get install -y chrpath
RUN apt-get install -y diffstat
RUN apt-get install -y gawk
RUN apt-get install -y texinfo
RUN apt-get install -y python
RUN apt-get install -y python3
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y build-essential
RUN apt-get install -y cpio
RUN apt-get install -y git-core
RUN apt-get install -y libssl-dev
RUN apt-get install -y quilt
RUN apt-get install -y cmake
RUN apt-get install -y libsqlite3-dev
RUN apt-get install -y libarchive-dev
RUN apt-get install -y python3-dev
RUN apt-get install -y libdb-dev
RUN apt-get install -y libpopt-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y locales
RUN apt-get install -y sudo
RUN apt-get install -y xterm
RUN apt-get install -y vim
RUN apt-get install -y tree
RUN apt-get install -y python-pip


RUN pip install multiprocessing

# Locale settings
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
        dpkg-reconfigure --frontend=noninteractive locales && \
        update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ARG gid=1000
RUN groupadd -g $gid user
ARG uid=1000
RUN useradd -u $uid -g user user
RUN mkdir /workdir && chown user /workdir
RUN mkdir -p /home/user && chown -R user:user /home/user

RUN echo "user ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

# Install AGL SDK

ENV AGL_SDK_ARCH=aarch64
ENV AGL_SDK_VERSION=7.90.0

ARG AGL_SDK=poky-agl-glibc-x86_64-agl-image-minimal-crosssdk-${AGL_SDK_ARCH}-toolchain-${AGL_SDK_VERSION}+snapshot.sh
ARG SDK_SITE=https://download.automotivelinux.org/AGL/snapshots/master/2019-04-23-b1121/m3ulcb-nogfx/deploy/sdk
RUN cd /home/user && wget -q $SDK_SITE/$AGL_SDK

# Install AGL SDK
RUN cd /home/user && chmod a+x $AGL_SDK && ./$AGL_SDK -y


USER user
ENV DISPLAY=:0

ARG CACHEBUST=1


ENV OE_CORE_PATH=/home/user/oe-core
ENV AAC_SDK_HOME=/home/user/aac-sdk

ENV AAC_REMOTE=https://github.com/iotbzh/aac-sdk.git

RUN cd ~ && git clone --recursive ${AAC_REMOTE}
RUN cd ~ && git clone git://git.openembedded.org/openembedded-core oe-core -b rocko
RUN cd ~/oe-core && git clone git://git.openembedded.org/bitbake -b 1.36


ENV HOST_SDK_HOME=${AAC_SDK_HOME}

RUN ${AAC_SDK_HOME}/builder/build.sh oe -t aglarm64  -DAGL_SDK=/opt/agl-sdk/${AGL_SDK_VERSION}+snapshot-${AGL_SDK_ARCH} ${AAC_SDK_HOME}/samples/audio

RUN cd ${AAC_SDK_HOME}/builder/deploy/aglarm64 && tar -xvf aac-image-minimal-aglarm64.tar.gz

ENV AAC_INSTALL_ROOT=${AAC_SDK_HOME}/builder/deploy/aglarm64/opt/AAC

#RUN xterm

RUN bash

COPY build_voice_agent.bash /home/user
COPY customize.bash /home/user

WORKDIR /home/user

ENTRYPOINT [ "/bin/bash" ]
