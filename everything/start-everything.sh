#!/bin/bash

IDENTITY="rd-all"
USERNAME="all-container"

CONTAINER=$(docker images --filter "label=identity=$IDENTITY" -q)

docker run -it --rm -v ~/.ssh:~/.ssh:ro $CONTAINER
