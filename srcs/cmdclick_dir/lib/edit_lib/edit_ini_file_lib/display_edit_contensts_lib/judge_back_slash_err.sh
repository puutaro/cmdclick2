#!/usr/bin/env bash


judge_back_slash_err(){
	local ini_value_source="${1}"
	case "${SIGNAL_CODE}" in
		"${EXIT_CODE}")
			return
			;;
	esac
	local exist_backslash=$(\
	echo "${ini_value_source}" \
		| grep '\\' \
		|| e=$? \
	)
	case "${exist_backslash}" in
		"") return 
			;;
	esac
	set +e
	webdi \
		form \
		--title="${WINDOW_TITLE}" \
		--keep \
		--window-icon="${WINDOW_ICON_PATH}" \
		--text="\nback slash is forbidden  \n" \
		--center \
    --font-size ${CMDCLICK_FORM_FONT_SIZE} \
    --borders=${CMDCLICK_FORM_PADDING} \
    --height=${CENTER_SCALE_DISPLAY_HEIGHT} \
    --width=${CENTER_SCALE_DISPLAY_WIDTH} \
    --id=${CMDCLICK_MACHINE_ID} \
		--button  gtk-ok:${OK_CODE}
	set -e
	ROOP_NUM=2
	SIGNAL_CODE=${EXIT_CODE}
}