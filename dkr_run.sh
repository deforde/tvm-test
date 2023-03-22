#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(realpath ${0%/*})
cd $SCRIPT_DIR

# docker run -v $PWD:/home/jenkins/models -it --workdir /home/jenkins/models tvm_test:latest
docker run \
    -v $PWD:/home/jenkins/models \
    --workdir /home/jenkins/models \
    tvm_test:latest \
    /usr/bin/bash -c \
    "tvmc compile \
    --target c \
    --runtime=crt \
    --executor=aot \
    --executor-aot-interface-api=c \
    --executor-aot-unpacked-api=1 \
    --output-format mlf \
    --pass-config tir.disable_vectorize=1 \
    model.tflite && \
    mkdir module && \
    mv module.tar module && \
    cd module && \
    tar xf module.tar \
    "
