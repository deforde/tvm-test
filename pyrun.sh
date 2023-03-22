#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(realpath ${0%/*})
cd $SCRIPT_DIR

if [[ ! -d .venv ]]; then
    python3 -m venv .venv
    source .venv/bin/activate
    python3 -m pip install matplotlib
fi

source .venv/bin/activate
python3 plt.py
