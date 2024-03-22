IMAGE_NAME=myhumble
CONTAINER_NAME=ros2

rocker --nvidia --x11 --env CONTAINER_NAME=$CONTAINER_NAME --network host --home --user --name $CONTAINER_NAME $IMAGE_NAME:latest $@
