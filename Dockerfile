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
RUN apt-get install -y ros-kinetic-control-msgs ros-kinetic-controller-manager ros-kinetic-effort-controllers ros-kinetic-gazebo-dev ros-kinetic-gazebo-msgs ros-kinetic-gazebo-plugins ros-kinetic-gazebo-ros ros-kinetic-gazebo-ros-control ros-kinetic-imu-complementary-filter ros-kinetic-imu-sensor-controller ros-kinetic-joint-state-controller ros-kinetic-joint-trajectory-controller ros-kinetic-joy ros-kinetic-moveit-ros-control-interface ros-kinetic-moveit-ros-move-group ros-kinetic-moveit-ros-planning ros-kinetic-moveit-ros-planning-interface ros-kinetic-moveit-ros-robot-interaction ros-kinetic-moveit-simple-controller-manager ros-kinetic-navigation ros-kinetic-pointcloud-to-laserscan ros-kinetic-position-controllers ros-kinetic-robot-controllers ros-kinetic-robot-localization ros-kinetic-ros-control ros-kinetic-ros-controllers ros-kinetic-rosbridge-server ros-kinetic-rosdoc-lite ros-kinetic-rqt-controller-manager ros-kinetic-velocity-controllers ros-kinetic-yocs-velocity-smoother
RUN apt-get install -y ros-melodic-control-msgs ros-melodic-controller-manager ros-melodic-effort-controllers ros-melodic-gazebo-dev ros-melodic-gazebo-msgs ros-melodic-gazebo-plugins ros-melodic-gazebo-ros ros-melodic-gazebo-ros-control ros-melodic-imu-complementary-filter ros-melodic-imu-sensor-controller ros-melodic-joint-state-controller ros-melodic-joint-trajectory-controller ros-melodic-joy ros-melodic-moveit-ros-control-interface ros-melodic-moveit-ros-move-group ros-melodic-moveit-ros-planning ros-melodic-moveit-ros-planning-interface ros-melodic-moveit-ros-robot-interaction ros-melodic-moveit-simple-controller-manager ros-melodic-navigation ros-melodic-pointcloud-to-laserscan ros-melodic-position-controllers ros-melodic-robot-controllers ros-melodic-robot-localization ros-melodic-ros-control ros-melodic-ros-controllers ros-melodic-rosbridge-server ros-melodic-rosdoc-lite ros-melodic-rqt-controller-manager ros-melodic-velocity-controllers ros-melodic-yocs-velocity-smoother
RUN apt-get install -y libncurses5-dev uvcdynctrl python3-yaml python-yaml python-catkin-pkg python-opencv python-numpy python-catkin-lint

# Python modules
RUN pip install tensorflow

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
