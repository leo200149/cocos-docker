FROM ubuntu:16.04

WORKDIR /

SHELL ["/bin/bash", "-c"]

## base
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
	wget \
	unzip \
	python-minimal \
	git \
	python-pip \
    software-properties-common \
	libgdk-pixbuf2.0-dev \
	libx11-dev \
	libxmu-dev \
	libglu1-mesa-dev \
	libgl2ps-dev \
	libxi-dev \
	libzip-dev \
	libpng-dev \
	libcurl4-gnutls-dev \
	libfontconfig1-dev \
	libsqlite3-dev \
	libglew-dev \
	libssl-dev \
	libgtk-3-dev \
	libglfw3 \
	libglfw3-dev \
	xorg-dev

##g++ 4.9
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y > /dev/null
RUN apt-get update && apt-get install g++-4.9 gcc-4.9 -y && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 50 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9 

##cmake 3.9.6
RUN wget https://cmake.org/files/v3.9/cmake-3.9.6-Linux-x86_64.sh && chmod +x *.sh && ./cmake-3.9.6-Linux-x86_64.sh --skip-license

## cocos
RUN wget http://digitalocean.cocos2d-x.org/Cocos2D-X/cocos2d-x-3.17.zip && unzip -o cocos2d-x-3.17.zip && mv /cocos2d-x-3.17 /cocos2d-x && rm -f cocos2d-x-3.17.zip 

## cocos download dependency and build
RUN cd /cocos2d-x && ./download-deps.py -r yes && mkdir build/linux-build && cd build/linux-build && cmake ../.. && make -j 4

## set env
RUN cd /cocos2d-x && ./setup.py -q true && source /root/.bashrc
ENV PATH "$PATH:/cocos2d-x/tools/cocos2d-console/bin"

## run test
RUN cocos -v --agreement n

## remove unused tools
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["tail", "-f", "/dev/null"]