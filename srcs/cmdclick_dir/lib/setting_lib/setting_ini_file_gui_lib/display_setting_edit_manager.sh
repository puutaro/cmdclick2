#!/usr/bin/env bash


display_setting_edit_manager(){
	local setting_con="${1}"
	local setting_edit_message="\n please set value\n\n"
	set +e
	SETTING_VALUE=$(\
		LANG="ja_JP.UTF-8" webdi form \
		--title="${WINDOW_TITLE}" \
		--keep \
		--window-icon="${WINDOW_ICON_PATH}" \
		--text="${setting_edit_message}" \
		--separator=$'\t' --item-separator="!" \
		--center \
		--scroll \
		--height=${CENTER_SCALE_DISPLAY_HEIGHT} \
		--width=${CENTER_SCALE_DISPLAY_WIDTH} \
		--button  gtk-cancel:${EXIT_CODE} \
		--button  gtk-ok:${OK_CODE} \
		--font-size ${CMDCLICK_FORM_FONT_SIZE} \
		--borders=${CMDCLICK_FORM_PADDING} \
		--id=${CMDCLICK_MACHINE_ID} \
		${setting_con} \
	)
	SIGNAL_CODE=$?
	set -e
}