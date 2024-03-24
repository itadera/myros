FROM osrf/ros:humble-desktop-full

# ENV WS_DIR="/root/ros2_ws"
SHELL ["/bin/bash", "-c"]

RUN sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && apt-get install -y git nano zsh terminator python3-argcomplete && rosdep update
# RUN mkdir -p $WS_DIR/src

#WORKDIR  $CATKIN_WS/src
#RUN git clone https://github.com/Automation-Research-Team/OpenHRC.git

# WORKDIR $CATKIN_WS/src/OpenHRC
#RUN git submodule update --init --recursive 
# RUN rosdep install -i -y --from-paths .

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["/bin/zsh"]
