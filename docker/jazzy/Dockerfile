FROM ros:jazzy-perception

SHELL ["/bin/bash", "-c"]

RUN sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y git nano zsh terminator python3-argcomplete openssh-server
RUN apt-get install --no-install-recommends -y ros-$ROS_DISTRO-desktop ros-$ROS_DISTRO-plotjuggler-ros

# install Gazebo Harmobic
RUN curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null \
    && apt-get update \
    && apt-get install --no-install-recommends -y gz-harmonic

# rosdep
COPY src/$ROS_DISTRO/*/src/ /root/workspace/
RUN rosdep update && rosdep install -i -y --from-paths /root//workspace
RUN rm -rf /root/workspace

# clean apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["/bin/zsh"]
