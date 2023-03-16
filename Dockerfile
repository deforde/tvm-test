from ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Africa/Johannesburg

RUN apt update && apt install -y \
    g++ \
    gcc \
    git \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install \
    Pillow==8.3.2 \
    apache-tvm \
    attrs==21.2.0 \
    cloudpickle==2.0.0 \
    decorator==5.1.0 \
    ethos-u-vela==3.5.0 \
    flatbuffers==1.12 \
    lxml==4.6.3 \
    nose==1.3.7 \
    numpy==1.19.5 \
    psutil==5.8.0 \
    scipy==1.5.4 \
    tflite==2.4.0 \
    tornado==6.1 \
    typing-extensions

RUN adduser --disabled-password --uid 1000 --gecos "" mruser
USER mruser

WORKDIR /home/mruser
RUN git clone --recursive https://github.com/apache/tvm
ENV TVM_INCLUDE_PATH=/home/mruser/tvm
ENV C_INCLUDE_PATH=/home/mruser/tvm/3rdparty/dlpack/include:$C_INCLUDE_PATH
ENV CPLUS_INCLUDE_PATH=/home/mruser/tvm/3rdparty/dlpack/include:$CPLUS_INCLUDE_PATH
ENV CC=/usr/bin/gcc
