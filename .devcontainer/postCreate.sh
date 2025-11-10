#!/bin/bash
apt update

rosdep update
cd /ariac_ws/
export PIP_BREAK_SYSTEM_PACKAGES=1
rosdep install --from-paths src --ignore-src -r -y | grep "apt-get install" | sed 's/.*apt-get install //' > /tmp/ros_dependencies.txt

#######
# Config ZSH
#######
# https://www.josephguadagno.net/2025/03/27/add-and-customize-oh-my-zsh-in-a-linux-development-container
# powerline fonts for zsh theme
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd .. && rm -rf fonts

# oh-my-zsh plugins

zsh -c 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k'
cd /ariac_ws/src/
cp .devcontainer/dotfiles/.zshrc ~
cp .devcontainer/dotfiles/.p10k.zsh ~