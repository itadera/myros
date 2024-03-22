IMAGE_NAME=mynoetic
CONTAINER_NAME=ros1

rocker --nvidia --x11 --env CONTAINER_NAME=$CONTAINER_NAME --network host --home --user --name $CONTAINER_NAME $IMAGE_NAME:latest $@
