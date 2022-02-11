FROM python:3.7.4-slim-buster

RUN apt-get update
    
# install libc
RUN apt-get -qq install gcc-multilib libsdl-dev libc6 libc6-dev || true

#install tools
RUN apt-get --no-install-recommends --allow-unauthenticated --fix-broken -y install \
        wget \
        unzip \
        bzip2 \
        make \
        vim \
        git \
        ca-certificates \
        scons \
        sudo \
        python-setuptools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && ldd --version 
    
    #install python plugin    
RUN pip install --upgrade pip \
    && pip install click pyyaml rt_thread_studio pytest


RUN git clone https://gitee.com/rtthread/ART-Pi-smart.git

ADD arm-linux-musleabi_for_x86_64-pc-linux-gnu.tar.xz /ART-Pi-smart/tools/gnu_gcc

RUN cd /ART-Pi-smart/tools/gnu_gcc \
    && tar -xf arm-linux-musleabi_for_x86_64-pc-linux-gnu.tar.xz \
    && rm -r arm-linux-musleabi_for_x86_64-pc-linux-gnu.tar.xz \
    && cd - \
    && cd ART-Pi-smart \
    && ./smart-env.sh && cd kernel/bsp/imx6ull-artpi-smart && scons
