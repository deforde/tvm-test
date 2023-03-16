#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(realpath ${0%/*})
cd $SCRIPT_DIR

# docker run -v $PWD:/home/mruser/models -it --workdir /home/mruser/models tvm_test:latest
docker run \
    -v $PWD:/home/mruser/models \
    --workdir /home/mruser/models \
    tvm_test:latest \
    /usr/bin/bash -c \
    "tvmc compile \
    --target \"c -keys=cpu -model=host\" \
    --runtime=crt \
    --runtime-crt-system-lib 1 \
    --executor=\"aot\" \
    --output-format mlf \
    --pass-config tir.disable_vectorize=1 \
    magic_wand.tflite && \
    mkdir module && \
    mv module.tar module && \
    cd module && \
    tar xf module.tar \
    "
