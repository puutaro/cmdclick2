#!/usr/bin/env bash

# Sublime Textのインストール
brew install --cask sublime-text

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
sudo chmod -R +x "${CMDCLICK_SRCS_DIR_PATH}"

# macOSの標準的なローカルBinパスを指定
readonly USER_LOCAL_BIN_CMDCLICK_PATH="/usr/local/bin/${APP_NAME}"
sudo rm -f "${USER_LOCAL_BIN_CMDCLICK_PATH}"
sudo ln -s "${CMDCLICK_SRCS_DIR_PATH}/cmdclick" "${USER_LOCAL_BIN_CMDCLICK_PATH}"

readonly INSTALL_DIR_PATH="${CLONE_DIR_PATH}/install/mac"
readonly LIBS_DIR_PATH="${INSTALL_DIR_PATH}/libs"
sudo chmod -R +x "${LIBS_DIR_PATH}"

# LIBS_DIR_PATH 内のスクリプトを実行
bash "${LIBS_DIR_PATH}/install_get_res.sh"
bash "${LIBS_DIR_PATH}/install_check_window.sh"
bash "${LIBS_DIR_PATH}/install_fastpaste.sh"
bash "${LIBS_DIR_PATH}/install_wmctrl.sh"
