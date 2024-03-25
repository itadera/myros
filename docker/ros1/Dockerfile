FROM osrf/ros:noetic-desktop-full

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && apt-get install -y git nano zsh terminator snap && rosdep update
RUN snap install plotjuggler-ros

WORKDIR  /root
RUN git clone https://github.com/itadera/OpenHRC.git

WORKDIR /root/OpenHRC
RUN git submodule update --init --recursive 
RUN rosdep install -i -y --from-paths .

WORKDIR /root
RUN rm -rf OpenHRC && apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["/bin/zsh"]
