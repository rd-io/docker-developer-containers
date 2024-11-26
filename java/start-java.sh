#!/bin/bash

IDENTITY="rd-java"
USERNAME="rd-container"

CONTAINER=$(docker images --filter "label=identity=$IDENTITY" -q)

docker run -it --rm -v ~/.ssh:/home/$USERNAME/.ssh:ro $CONTAINER
#docker run -it -v ~/.ssh:/home/$USERNAME/.ssh:ro $CONTAINER