#!/bin/bash

abs_dirname() {
  local cwd="$(pwd)"
  local path="$1"

  while [ -n "$path" ]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$(readlink "$name" || true)"
  done

  pwd -P
  cd "$cwd"
}

SCRIPT_DIR="$(abs_dirname "$0")"
MODE=$1
cd $SCRIPT_DIR/..

if [[ $MODE == "ros1" ]]; then
  IMAGE_NAME="mynoetic"
elif [[ $MODE == "ros2" ]]; then
  IMAGE_NAME="myhumble"
else
  echo "ros1 or ros2?"
  return
fi

docker build -f $SCRIPT_DIR/$MODE/Dockerfile -t $IMAGE_NAME . 
