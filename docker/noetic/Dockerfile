FROM ros:noetic-perception

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y git nano zsh terminator openssh-server
RUN apt-get install --no-install-recommends -y ros-$ROS_DISTRO-desktop-full ros-$ROS_DISTRO-plotjuggler-ros

# rosdep
COPY src/$ROS_DISTRO/*/src/ /root/workspace/
RUN rosdep update && rosdep install -i -y --from-paths /root//workspace
RUN rm -rf /root/workspace

# clean apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["/bin/zsh"]
