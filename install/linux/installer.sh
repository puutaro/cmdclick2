#!/usr/bin/env bash

set -ue

echo "type sudo password"
sudo -v
readonly USRLOCALBIN="/usr/local/bin"

# 1. 必要なパッケージのインストール
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y yad wmctrl x11-xserver-utils xdotool xclip wget curl gnupg

# 2. Sublime Text のインストール (Ubuntu/Debian推奨の手順)
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.skel > /dev/null
echo "deb [signed-by=/etc/apt/trusted.gpg.skel] https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update -y
sudo apt-get install sublime-text -y

if [ ! -L "${USRLOCALBIN}/subl" ]; then
  sudo ln -s /opt/sublime_text/sublime_text "${USRLOCALBIN}/subl"
fi

# 3. cmdclick のインストール
readonly APP_NAME="cmdclick"
readonly versionNum=2
readonly CLONE_DIR_PATH="${HOME}/.${APP_NAME}${versionNum}"

# 既存のディレクトリを削除してクローン
rm -rf "${CLONE_DIR_PATH}"
git clone https://github.com/puutaro/cmdclick.git "${CLONE_DIR_PATH}"

# 正しいリポジトリ構造に合わせたパスの定義
readonly CMDCLICK_LINUX_SRCS_DIR_PATH="${CLONE_DIR_PATH}/linux/srcs"
readonly INSTALL_DIR_PATH="${CLONE_DIR_PATH}/linux/install"

# 権限変更
sudo chmod -R +x "${CMDCLICK_LINUX_SRCS_DIR_PATH}"

# シンボリックリンク作成
readonly USER_LOCAL_BIN_CMDCLICK_PATH="${USRLOCALBIN}/${APP_NAME}"
sudo rm -f "${USER_LOCAL_BIN_CMDCLICK_PATH}"
sudo ln -s "${CMDCLICK_LINUX_SRCS_DIR_PATH}/cmdclick" "${USER_LOCAL_BIN_CMDCLICK_PATH}"

# デスクトップファイルとアイコンの配置
readonly USR_SHARE_APP_DIR_PATH="/usr/share/applications"
readonly FILES_LIB_PATH="${INSTALL_DIR_PATH}/files"

if [ -d "${FILES_LIB_PATH}" ]; then
  sudo cp -arf "${FILES_LIB_PATH}/cmdclick.desktop" "${USR_SHARE_APP_DIR_PATH}/"
fi

# アイコン画像の名前（公式のインストーラーに合わせる場合は要確認）
readonly cmdclick_png_file_name="cmdclick_image.png"
readonly cmdclick_png_src_path="${CMDCLICK_LINUX_SRCS_DIR_PATH}/cmdclick_dir/images/${cmdclick_png_file_name}"
readonly cmdclick_png_dest_path="/usr/share/icons/${cmdclick_png_file_name}"

if [ -f "${cmdclick_png_src_path}" ]; then
  sudo cp -arvf "${cmdclick_png_src_path}" "${cmdclick_png_dest_path}"
fi

echo "インストールが完了しました。"
