#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(realpath ${0%/*})
cd $SCRIPT_DIR

docker build -t tvm_test:latest .
