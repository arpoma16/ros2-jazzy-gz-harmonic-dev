FROM nistariac/ariac2025:latest
RUN apt update
RUN apt install -y ros-jazzy-rmf-dev
RUN apt install -y ros-jazzy-rosbridge-server
RUN apt install -y ros-jazzy-gz-ros2-control ros-jazzy-gz-ros2-control-demos
RUN apt install -y ros-jazzy-dynamixel-sdk
RUN apt install -y ros-jazzy-dynamixel-interfaces
RUN apt install -y ros-jazzy-depthai-descriptions
RUN apt install -y ros-jazzy-realsense2-description
RUN apt install -y ros-jazzy-robotiq-description
RUN apt install -y ros-jazzy-zed-msgs
RUN apt install -y ros-jazzy-moveit-py
RUN apt install -y python3-paho-mqtt
RUN apt install -y ros-jazzy-nav2-common
RUN apt install -y ros-jazzy-nav2-bringup
RUN apt install -y ros-jazzy-nav2-route
RUN apt install -y ros-jazzy-robot-localization
RUN apt install -y ros-jazzy-moveit-py
RUN apt install -y ros-jazzy-moveit-configs-utils
RUN apt install -y ros-jazzy-moveit-ros-move-group
RUN apt install -y ros-jazzy-moveit-kinematics
RUN apt install -y ros-jazzy-moveit-planners
RUN apt install -y ros-jazzy-moveit-simple-controller-manager
RUN apt install -y ros-jazzy-moveit-msgs
RUN apt install -y ros-jazzy-moveit-ros-planning
RUN apt install -y ros-jazzy-moveit-ros-planning-interface
RUN apt install -y ros-jazzy-moveit-servo
RUN apt install -y python3-paho-mqtt
RUN apt install -y python3-flask-socketio
RUN apt install -y ros-jazzy-laser-filters
RUN apt install -y python3-libgpiod
RUN apt install -y python3-pyudev
RUN apt install -y python3-serial
RUN apt install -y python3-sh
RUN apt install -y usbutils
RUN apt install -y ros-jazzy-dynamixel-sdk
RUN apt install -y ros-jazzy-dynamixel-interfaces
RUN apt install -y ros-jazzy-depthai-descriptions
RUN apt install -y ros-jazzy-realsense2-description
RUN apt install -y ros-jazzy-robotiq-description
RUN apt install -y ros-jazzy-zed-msgs
RUN apt install -y ros-jazzy-moveit-setup-assistant
RUN apt install -y ros-jazzy-gazebo-msgs
RUN apt install -y python3-fastapi
RUN apt install -y python3-pydantic
RUN apt install -y python3-uvicorn


# RUN apt install -y curl wget
# RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
# RUN apt install -y nodejs

RUN curl -fsSL https://get.pnpm.io/install.sh | bash -
RUN export PATH="/root/.local/share/pnpm:$PATH" && pnpm env use --global lts
RUN echo 'export PATH="/root/.local/share/pnpm:$PATH"' >> ~/.bashrc
RUN apt install -y python3-pip python3-venv