FROM ros:noetic

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y git nano zsh terminator openssh-server && rosdep update
RUN apt-get install --no-install-recommends -y ros-$ROS_DISTRO-plotjuggler-ros

COPY ros1/ /root/workspace

WORKDIR /root/workspace
RUN rosdep install -i -y --from-paths .

WORKDIR /root
RUN rm -rf /root/workspace && apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["/bin/zsh"]
