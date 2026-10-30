FROM nistariac/ariac2025:latest
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-jazzy-rmf-dev \
    ros-jazzy-rosbridge-suite \
    ros-jazzy-ament-cmake-mypy \
    python3-tornado \
    python3-bson \
    python3-cbor2 \
    ros-jazzy-gz-ros2-control \
    ros-jazzy-gz-ros2-control-demos \
    ros-jazzy-dynamixel-sdk \
    ros-jazzy-dynamixel-interfaces \
    ros-jazzy-depthai-descriptions \
    ros-jazzy-realsense2-description \
    ros-jazzy-robotiq-description \
    ros-jazzy-zed-msgs \
    ros-jazzy-moveit-py \
    ros-jazzy-moveit-configs-utils \
    ros-jazzy-moveit-ros-move-group \
    ros-jazzy-moveit-kinematics \
    ros-jazzy-moveit-planners \
    ros-jazzy-moveit-simple-controller-manager \
    ros-jazzy-moveit-msgs \
    ros-jazzy-moveit-ros-planning \
    ros-jazzy-moveit-ros-planning-interface \
    ros-jazzy-moveit-servo \
    ros-jazzy-moveit-setup-assistant \
    ros-jazzy-nav2-common \
    ros-jazzy-nav2-bringup \
    ros-jazzy-nav2-route \
    ros-jazzy-robot-localization \
    ros-jazzy-laser-filters \
    ros-jazzy-gazebo-msgs \
    ros-jazzy-stereo-image-proc \
    ros-jazzy-rqt-tf-tree \
    ros-jazzy-topic-tools \
    python3-paho-mqtt \
    python3-flask-socketio \
    python3-flask-cors \
    python3-fastapi \
    python3-pydantic \
    python3-uvicorn \
    python3-libgpiod \
    python3-pyudev \
    python3-serial \
    python3-sh \
    usbutils \
    && rm -rf /var/lib/apt/lists/*



# RUN apt install -y curl wget
# RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
# RUN apt install -y nodejs
#RUN wget -qO- https://get.pnpm.io/install.sh | ENV="$HOME/.shrc" SHELL="$(which sh)" sh -
SHELL ["/bin/bash", "-c"]
RUN curl -fsSL https://get.pnpm.io/install.sh | bash -
RUN source ./.bashrc && export PATH="/root/.local/share/pnpm:$PATH" && pnpm env use --global lts
RUN echo 'export PATH="/root/.local/share/pnpm:$PATH"' >> ~/.bashrc
RUN apt install -y python3-pip python3-venv