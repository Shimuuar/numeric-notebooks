#!/bin/sh
#
# Script which sets up and runs jupyter

set -e

# We keep configuration on /dev/shm on volatile TMPFS. It's
# regenerated on each start
if [ -L .XDG ]; then
    # Reuse old directory
    mkdir -p $(readlink .XDG)
elif [ -e .XDG ]; then
    # It's not a link. Abort!
    echo "error: .XDG is not a symlink"
    exit 1;
else
    # Create dir and symlink it
    ln -s $(mktemp -d --tmpdir=/dev/shm jupyter-XDG-XXXXXX) .XDG
fi
# Clean up configudation
rm -rf .XDG/*

# Install kernels
ihaskell   install

# Start jupyter in notebook directory
jupyter notebook --no-browser

