FROM osrf/ros:kinetic-desktop-full

# Arguments
ARG user
ARG uid
ARG home
ARG workspace
ARG shell

# Basic Utilities
RUN apt-get -y update && apt-get install -y zsh screen tmux tree sudo ssh synaptic htop vim tig ipython ipython3 less

# Additional development tools
RUN apt-get install -y x11-apps python-pip python3-pip build-essential python-catkin-tools

# Additional custom dependencies
RUN apt-get install -y libncurses5-dev ros-kinetic-control-msgs ros-kinetic-controller-manager ros-kinetic-effort-controllers ros-kinetic-gazebo-dev ros-kinetic-gazebo-msgs ros-kinetic-gazebo-plugins ros-kinetic-gazebo-ros ros-kinetic-gazebo-ros-control ros-kinetic-imu-complementary-filter ros-kinetic-imu-sensor-controller ros-kinetic-joint-state-controller ros-kinetic-joint-trajectory-controller ros-kinetic-joy ros-kinetic-moveit-ros-control-interface ros-kinetic-moveit-ros-move-group ros-kinetic-moveit-ros-planning ros-kinetic-moveit-ros-planning-interface ros-kinetic-moveit-ros-robot-interaction ros-kinetic-moveit-simple-controller-manager ros-kinetic-navigation ros-kinetic-pointcloud-to-laserscan ros-kinetic-position-controllers ros-kinetic-robot-controllers ros-kinetic-robot-localization ros-kinetic-ros-control ros-kinetic-ros-controllers ros-kinetic-rosbridge-server ros-kinetic-rosdoc-lite ros-kinetic-rqt-controller-manager ros-kinetic-velocity-controllers ros-kinetic-yocs-velocity-smoother uvcdynctrl

# Python modules
RUN pip install catkin_pkg PyYAML tensorflow opencv-python
RUN pip3 install PyYAML

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
