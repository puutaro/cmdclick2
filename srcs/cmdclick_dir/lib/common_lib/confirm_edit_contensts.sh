#!/usr/bin/env bash


#yad用入力値反映イニファイル内容を作成
confirm_edit_contensts(){
	local LANG="ja_JP.UTF-8" 
	local display_ini_contents="${1}"
#	local display_ini_contents=$(\
#	echo  "${1}" \
#		| sed -e 's/\&/\&amp;/g' \
#		 -e 's/</\&lt;/g' \
#		 -e 's/>/\&gt;/g' \
#		 -e 's/"/\&quot;/g' \
#		 -e "s/'/\&apos;/g" \
#	)
	local save_confirm_message="\n Do you really want to save bellow ini file ? \n"
	set +e
	webdi \
		form \
		--title="${WINDOW_TITLE}" \
    --keep \
		--window-icon="${WINDOW_ICON_PATH}" \
		--item-separator='!'\
		--center \
		--scroll \
		--height=${CENTER_SCALE_DISPLAY_HEIGHT} \
		--width=${CENTER_SCALE_DISPLAY_WIDTH} \
		--separator=${ITEM_THREAD} \
    --font-size ${CMDCLICK_FORM_FONT_SIZE} \
    --borders=${CMDCLICK_FORM_PADDING} \
    --id=${CMDCLICK_MACHINE_ID} \
		--field="base64://$(echo "$save_confirm_message:LBL" | base64 -w 0)" \
		--field="base64://$(echo "$display_ini_contents:LBL" | base64 -w 0)"
	CONFIRM=$?
	set -e
}