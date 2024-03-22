IMAGE_NAME=mynoetic
CONTAINER_NAME=ros1

rocker --nvidia --x11 --network host --home --user --name $CONTAINER_NAME $IMAGE_NAME:latest $@
