FROM osrf/ros:noetic-desktop-full

ENV CATKIN_WS="/root/catkin_ws"
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get upgrade -y && apt-get install -y git nano zsh && rosdep update
RUN mkdir -p $CATKIN_WS/src

WORKDIR  $CATKIN_WS/src
RUN git clone https://github.com/Automation-Research-Team/OpenHRC.git

WORKDIR $CATKIN_WS/src/OpenHRC
RUN git submodule update --init --recursive 
RUN rosdep install -i -y --from-paths .

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["/bin/zsh"]
