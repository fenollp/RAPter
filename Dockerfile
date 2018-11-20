FROM ubuntu:18.04
MAINTAINER Pierre Fenoll <pierrefenoll@gmail.com>
# docker build --compress --force-rm --pull --tag fenollp/rapter .
# docker run --rm -it -v "$PWD":/app/rapter fenollp/rapter

# Use bash instead of sh for pushd & just being sane
SHELL ["/bin/bash", "-c"]

RUN set -x \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt update && apt upgrade -y \
 && apt install -y \
      python-pygraphviz build-essential ca-certificates \
      subversion liblapack-dev libblas-dev fortran-compiler wget \
      git cmake libgl1-mesa-dev \
      libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev \
      python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev \
      libboost-all-dev libopenni0 libopenni-dev libeigen3-dev libflann1.9 libflann-dev vtk6 libqhull7 libqhull-dev

WORKDIR /app/3rdparty
RUN set -x \
 && svn co https://projects.coin-or.org/svn/Bonmin/stable/1.5 Bonmin \
 && pushd Bonmin \
 && pushd ThirdParty/Mumps && ./get.Mumps && popd \
 && export MAKEFLAGS="-j$(getconf _NPROCESSORS_ONLN)" \
 && mkdir build && pushd build && ../configure -C && make && make install && popd \
 && popd

WORKDIR /app/3rdparty
RUN set -x \
 && git clone --depth=1 --branch=v1.3 https://github.com/mkirchner/libfbi.git

WORKDIR /app/3rdparty
RUN set -x \
 && git clone --depth=1 --branch=3.4.1 https://github.com/opencv/opencv.git \
 && mkdir opencv/build && pushd opencv/build \
 && export MAKEFLAGS="-j$(getconf _NPROCESSORS_ONLN)" \
 && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. \
 && make && make install && popd

WORKDIR /app/3rdparty
RUN set -x \
 && git clone https://github.com/PointCloudLibrary/pcl.git && pushd pcl \
 && git checkout d3b500a9033e620 && mkdir build && pushd build \
 && export MAKEFLAGS="-j$(getconf _NPROCESSORS_ONLN)" \
 && cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo .. && make && make install && popd && popd

WORKDIR /app/rapter/RAPter
RUN set -x \
 && ln -s /app $HOME/workspace
#&& git clone --branch=spatially_smooth https://github.com/amonszpart/RAPter.git rapter \
#&& pushd rapter/RAPter && git checkout 8f1f9a3 \
#&& export MAKEFLAGS="-j$(getconf _NPROCESSORS_ONLN)" \
#&& mkdir build && pushd build && cmake -DCMAKE_BUILD_TYPE=Release .. && make && popd \
#&& popd
