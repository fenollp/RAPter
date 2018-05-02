FROM ubuntu:18.04
MAINTAINER Pierre Fenoll <pierrefenoll@gmail.com>
# docker build --compress --force-rm --pull --tag rapter .
# docker run --rm -it -v "$PWD":/app/rapter rapter

# Use bash instead of sh for pushd & just being sane
SHELL ["/bin/bash", "-c"]

RUN set -x \
 && apt update && apt upgrade -y \
 && apt install -y \
      python-pygraphviz build-essential ca-certificates \
      subversion liblapack-dev libblas-dev fortran-compiler wget \
      git cmake

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

WORKDIR /app/rapter
RUN set -x \
 && ln -s /app $HOME/workspace
#&& git clone --branch=spatially_smooth https://github.com/amonszpart/RAPter.git rapter \
#&& pushd rapter/RAPter && git checkout 8f1f9a3 \
#&& export MAKEFLAGS="-j$(getconf _NPROCESSORS_ONLN)" \
#&& mkdir build && pushd build && cmake -DCMAKE_BUILD_TYPE=Release .. && make && popd \
#&& popd
