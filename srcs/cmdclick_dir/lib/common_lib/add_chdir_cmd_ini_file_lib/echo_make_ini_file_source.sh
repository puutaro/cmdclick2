#!/usr/bin/env bash

echo_make_ini_file_source(){
	local ini_file_name="${1}"
	local main_contents="${2}"

	# 1. sed_ini_file_name の特殊文字エスケープ処理を Bash 内蔵の変数展開で超高速化
	# ([^a-zA-Z0-9_-]) に該当する記号の直前に \ を挿入
	local sed_ini_file_name="${ini_file_name//[^\/a-zA-Z0-9_-]/\\&}"

	# 2. INI_SETTING_DEFAULT_GAIN_CON の変数展開置換
	#    - INI_TERMINAL_ON=... を OFF に置換
	#    - INI_CMD_FILE_NAME= に "sed_ini_file_name" を付与
	#    - INI_SET_VARIABLE_TYPE= に =CH_DIR_PATH:MDIR= を付与
	local gain_con="${INI_SETTING_DEFAULT_GAIN_CON}"
	gain_con="$(echo "${gain_con}" | sed -E \
		-e "s/${INI_TERMINAL_ON}=.*/${INI_TERMINAL_ON}=OFF/" \
		-e "s/(${INI_CMD_FILE_NAME}=)/\1\"${sed_ini_file_name}\"/" \
		-e "s/(${INI_SET_VARIABLE_TYPE})=/\1=${CH_DIR_PATH}:MDIR=/")"

	# 3. INI_CMD_VARIABLE_SECTION_DEFAULT の 2 行目に挿入
	local cmd_var="${INI_CMD_VARIABLE_SECTION_DEFAULT}"
	cmd_var="$(echo "${cmd_var}" | sed "2i${CH_DIR_PATH}=\"${create_chdir_path}\"")"

	# 4. ヒアドキュメント一発で全出力を結合生成（サブプロセス激減）
	cat << EOF
${CMDCLICK_CREATE_FILE_SHIBAN}


${INI_LABELING_SECTION_START_NAME}
${INI_LABELING_SECTION_END_NAME}


${INI_SETTING_SECTION_START_NAME}
${gain_con}
${INI_SETTING_SECTION_END_NAME}


${cmd_var}


${SEARCH_INI_CMD_SECTION_START_NAME}
${main_contents}
EOF
}
#echo_make_ini_file_source(){
#	local ini_file_name="${1}"
#	local main_contents="${2}"
#	local sed_ini_file_name="$(\
#		echo "${ini_file_name}" \
#			| sed -r 's/([^a-zA-Z0-9_-])/\\\1/g'
#	)"
#	cat <(echo "${CMDCLICK_CREATE_FILE_SHIBAN}") \
#		<(echo -e "") \
#		<(echo -e "") \
#		<(echo "${INI_LABELING_SECTION_START_NAME}")  \
#		<(echo "${INI_LABELING_SECTION_END_NAME}")  \
#		<(echo -e "") \
#		<(echo -e "") \
#		<(echo "${INI_SETTING_SECTION_START_NAME}")  \
#		<(\
#			echo "${INI_SETTING_DEFAULT_GAIN_CON}" \
#			| sed \
#				-e 's/'${INI_TERMINAL_ON}'=.*/'${INI_TERMINAL_ON}'=OFF/' \
#				-re "s/(${INI_CMD_FILE_NAME}=)/\1\"${sed_ini_file_name}\"/" \
#				-re "s/(${INI_SET_VARIABLE_TYPE})=/\1=${CH_DIR_PATH}:MDIR=/" \
#		) \
#		<(echo "${INI_SETTING_SECTION_END_NAME}"\
#		) \
#		<(echo -e "\n") \
#		<(\
#			echo "${INI_CMD_VARIABLE_SECTION_DEFAULT}" \
#				| sed "2i${CH_DIR_PATH}=\"${create_chdir_path}\"") \
#		<(echo -e "\n") \
#		<(echo "${SEARCH_INI_CMD_SECTION_START_NAME}") \
#		<(echo "${main_contents}")
#}