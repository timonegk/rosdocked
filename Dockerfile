FROM ubuntu:18.04

# Arguments
ARG user
ARG uid
ARG home
ARG workspace
ARG shell

# Basic Utilities
RUN apt-get -y update && apt-get install -y apt-utils && apt-get -y upgrade && apt-get install -y zsh screen tmux tree sudo ssh synaptic htop vim tig ipython ipython3 less ranger gdb iproute2 iputils-ping vlc beignet wget gnupg2 locales

# Setup locale
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && locale-gen && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Setup packages.bit-bots.de apt source
RUN wget http://packages.bit-bots.de/key.asc -O- | apt-key add -
RUN echo "deb http://packages.bit-bots.de bionic main" > /etc/apt/sources.list.d/ros.list
RUN apt-get update

# Additional development tools
RUN apt-get install -y x11-apps python3-pip build-essential

# Additional custom dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y ros-melodic-desktop-full ros-melodic-control-msgs ros-melodic-controller-manager ros-melodic-effort-controllers ros-melodic-gazebo-dev ros-melodic-gazebo-msgs ros-melodic-gazebo-plugins ros-melodic-gazebo-ros ros-melodic-gazebo-ros-control ros-melodic-imu-complementary-filter ros-melodic-imu-sensor-controller ros-melodic-joint-state-controller ros-melodic-joint-trajectory-controller ros-melodic-joy ros-melodic-moveit-ros-control-interface ros-melodic-moveit-ros-move-group ros-melodic-moveit-ros-planning ros-melodic-moveit-ros-planning-interface ros-melodic-moveit-ros-robot-interaction ros-melodic-moveit-simple-controller-manager ros-melodic-navigation ros-melodic-pointcloud-to-laserscan ros-melodic-position-controllers ros-melodic-robot-controllers ros-melodic-robot-localization ros-melodic-ros-control ros-melodic-ros-controllers ros-melodic-rosdoc-lite ros-melodic-rqt-controller-manager ros-melodic-velocity-controllers ros-melodic-yocs-velocity-smoother ros-melodic-rviz-imu-plugin
RUN apt-get install -y libncurses5-dev uvcdynctrl python3-yaml python3-opencv python3-numpy

# Python modules
RUN pip3 install pip --upgrade
RUN pip3 install git+https://github.com/catkin/catkin_tools.git

# Mount the user's home directory
VOLUME "${home}"

# Clone user into docker image and set up X11 sharing 
RUN \
  echo "${user}:x:${uid}:${uid}:${user},,,:${home}:${shell}" >> /etc/passwd && \
  echo "${user}:x:${uid}:" >> /etc/group && \
  echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" && \
  chmod 0440 "/etc/sudoers.d/${user}"

# Switch to user
USER "${user}"
# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1
ENV CATKIN_TOPLEVEL_WS="${workspace}/devel"
# Switch to the workspace
WORKDIR ${workspace}
