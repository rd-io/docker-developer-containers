#!/bin/bash

IDENTITY="rd-all"
USERNAME="rd-container"

CONTAINER=$(docker images --filter "label=identity=$IDENTITY" -q)

docker run -it --rm -v ~/.ssh:/home/$USERNAME/.ssh:ro $CONTAINER
