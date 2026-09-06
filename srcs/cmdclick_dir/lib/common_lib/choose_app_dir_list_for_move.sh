#!/usr/bin/env bash


choose_app_dir_list_for_move(){
	local LANG="ja_JP.UTF-8"
	local ifs_local="${IFS}"
	local IFS=$'\n'
	local ini_file_con="$(cat "${CMDCLICK_APP_LIST_PATH}")"
	local ini_file_list="${ini_file_con%%$'\n'*}"
	local IFS="${ifs_local}"
	local title_message="\n please click app dir you want to move"
	title_message+="\n\t(current app dir: ${ini_file_list}) \n"
	set +e
	echo "${ini_file_con}" \
  |  guigui \
      list \
      --window-icon="${WINDOW_ICON_PATH}" \
      --keep \
      --title="${WINDOW_TITLE}" \
      --text="${title_message}" \
      --height=${CENTER_SCALE_DISPLAY_HEIGHT} \
      --width=${CENTER_SCALE_DISPLAY_WIDTH} \
      --center \
      --font-size ${CMDCLICK_LIST_FONT_SIZE} \
      --borders=${CMDCLICK_LIST_PADDING} \
      --id=${CMDCLICK_MACHINE_ID}
	set -e
}