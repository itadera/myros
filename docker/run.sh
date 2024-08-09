#!/bin/bash

CONTAINER_NAME=$1

# if [[ $CONTAINER_NAME == "ros1" ]]; then
#   IMAGE_NAME="mynoetic"
# elif [[ $CONTAINER_NAME == "ros2" ]]; then
#   IMAGE_NAME="myhumble"
# else
#   echo "ros1 or ros2?"
#   return
# fi

IMAGE_NAME="my$CONTAINER_NAME"



shopt -s nocasematch
NVIDIA_FLAG=""
if [[ $(lspci | grep -i '.* vga .* nvidia .*') == *' nvidia '* ]]; then
  NVIDIA_FLAG="--nvidia"
fi

rocker $NVIDIA_FLAG --x11 --env CONTAINER_NAME=$CONTAINER_NAME --network host --home --user --name $CONTAINER_NAME $IMAGE_NAME:latest $2
