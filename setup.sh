#!/bin/sh

if [ -d py ]; then
    echo "py directory already exists"
    exit 1
fi

# Install jupyter
set -e
virtualenv py
. py/bin/activate
pip install jupyter
pip install nbstripout
