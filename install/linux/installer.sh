#!/usr/bin/env bash

set -ue

# install require pkg
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y yad wmctrl x11-xserver-utils xdotool xclip wget curl gnupg

# install sublime (Official APT method)
sudo install -d -m 0755 /etc/apt/keyrings
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null
echo -e "Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc" | sudo tee /etc/apt/sources.list.d/sublime-text.sources
sudo apt-get update -y
sudo apt-get install sublime-text -y

readonly USRLOCALBIN="/usr/local/bin"
if [ ! -L "${USRLOCALBIN}/subl" ]; then
  sudo ln -s /opt/sublime_text/sublime_text "${USRLOCALBIN}/subl"
fi

# install guigui
curl https://raw.githubusercontent.com/puutaro/guigui/refs/heads/master/install.sh \
| bash

# install cmdclick
readonly APP_NAME="cmdclick"
readonly versionNum=2
readonly CLONE_DIR_PATH="${HOME}/.${APP_NAME}${versionNum}"

rm -rf "${CLONE_DIR_PATH}"
git clone https://github.com/puutaro/cmdclick.git "${CLONE_DIR_PATH}"

readonly CMDCLICK_SRCS_DIR_PATH="${CLONE_DIR_PATH}/srcs"
readonly INSTALL_DIR_PATH="${CLONE_DIR_PATH}/install/linux"
sudo chmod -R +x "${CMDCLICK_SRCS_DIR_PATH}"
readonly USER_LOCAL_BIN_CMDCLICK_PATH="${USRLOCALBIN}/${APP_NAME}"
sudo rm -f "${USER_LOCAL_BIN_CMDCLICK_PATH}"
sudo ln -s "${CMDCLICK_SRCS_DIR_PATH}/cmdclick" "${USER_LOCAL_BIN_CMDCLICK_PATH}"
readonly USR_SHARE_APP_DIR_PATH="/usr/share/applications"
readonly FILES_LIB_PATH="${INSTALL_DIR_PATH}/files"

if [ -d "${FILES_LIB_PATH}" ]; then
  sudo cp -arf "${FILES_LIB_PATH}/cmdclick.desktop" "${USR_SHARE_APP_DIR_PATH}/"
fi
readonly cmdclick_png_file_name="cmdclick_image.png"
readonly cmdclick_png_src_path="${CMDCLICK_SRCS_DIR_PATH}/cmdclick_dir/images/${cmdclick_png_file_name}"
readonly cmdclick_png_dest_path="/usr/share/icons/${cmdclick_png_file_name}"

if [ -f "${cmdclick_png_src_path}" ]; then
  sudo cp -arvf "${cmdclick_png_src_path}" "${cmdclick_png_dest_path}"
fi
