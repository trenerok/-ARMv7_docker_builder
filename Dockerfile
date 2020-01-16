#
# Build Python for armv7 Dockerfile
#
# https://github.com/trenerok/-ARMv7_docker_builder
#

FROM resin/armv7hf-debian-qemu

MAINTAINER "Pol Smith" <@trenerok>

VOLUME /src
VOLUME /target
ARG PYTHON_VERSION=3.7.5
ARG OPENSSL_VERSION=1.1.1b
ARG OPENSSL_PATH=/usr/local/openssl

ENV PATH $OPENSSL_PATH/bin:$PATH
ENV LD_LIBRARY_PATH $OPENSSL_PATH/lib
ENV LDFLAGS -L$OPENSSL_PATH/lib -Wl,-rpath,$OPENSSL_PATH/lib

ENV PYTHON_VERSION $PYTHON_VERSION
ENV OPENSSL_VERSION $OPENSSL_VERSION
ENV OPENSSL_PATH $OPENSSL_PATH


RUN echo "deb http://deb.debian.org/debian/ oldstable main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian/ oldstable-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian-security oldstable/updates main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -qy --no-install-recommends \
        curl wget apt-transport-https dirmngr build-essential \
        libsqlite3-dev libgnutls28-dev libgnutls-openssl27 libssl-dev libbz2-dev libreadline-dev \
        zlib1g-dev xz-utils liblzma-dev libffi-dev libncurses5-dev libreadline-dev libtk8.5 libgdm-dev libdb4o-cil-dev libpcap-dev

RUN wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz -O - | tar -xz
WORKDIR /openssl-${OPENSSL_VERSION}
RUN ./config --prefix=${OPENSSL_PATH} --openssldir=${OPENSSL_PATH} && make && make install

ENTRYPOINT wget -q -O /src/Python-${PYTHON_VERSION}.tgz https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
cd /src && tar -zxvf Python-${PYTHON_VERSION}.tgz && cd Python-${PYTHON_VERSION} && \
./configure --prefix=/target/python-${PYTHON_VERSION} --disable-shared --with-openssl=${OPENSSL_PATH} --with-ensurepip=yes CFLAGS="-I${OPENSSL_PATH}/include" LDFLAGS="-L${OPENSSL_PATH}/lib" && \
MAKEFLAGS="-j 4" make && MAKEFLAGS="-j 4" make install && \ 
cp ${OPENSSL_PATH}/lib/libcrypto.so.* ${OPENSSL_PATH}/lib/libssl.so.* /target/
 
