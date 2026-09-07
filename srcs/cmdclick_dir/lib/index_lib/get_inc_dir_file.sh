#!/usr/bin/env bash

get_inc_dir_file(){
	local sed_home="${HOME//\//\\\/}"
	local change_dir_path_con=""

	# 1. macOS (BSD) と Linux (GNU) の ls -tl の出力揺れを一切排除し、
	#    更新日時順 (ls -1t) で cat コマンド群の文字列を高速生成
	while IFS= read -r file_path; do
		[ -f "${file_path}" ] || continue
		change_dir_path_con+="cat \"${file_path}\"; "
	done < <(ls -1t "${CMDCLICK_APP_DIR_PATH}"/*.sh 2>/dev/null)

	[ -z "${change_dir_path_con}" ] && { : > "${CMDCLICK_APP_LIST_PATH}"; return 0; }

	# 2. 元のパイプ処理と全く同じ順番・構造で一括処理
	#    (sed も GNU/BSD 共通の安全なオプションで一発実行)
	bash -c "${change_dir_path_con}" \
		| fetch_parameter_from_pip "${CH_DIR_PATH}" \
		| sed \
			-e "s|\$HOME|${HOME}|g" \
			-e "s|\${HOME}|${HOME}|g" \
			-e 's/^"//' \
			-e 's/"$//' > "${CMDCLICK_APP_LIST_PATH}"
}

#get_inc_dir_file(){
#	local sed_home="${HOME//\//\\\/}"
#	local change_dir_path_con=$(\
#		ls -tl "${CMDCLICK_APP_DIR_PATH}" \
#		| awk -v CMDCLICK_APP_DIR_PATH="${CMDCLICK_APP_DIR_PATH}" \
#		'
#		{
#			file_name = substr($0, index($0, $9), length($0))
#			gsub(/^\x27/, "", file_name)
#			gsub(/\x27$/, "", file_name)
#			if(!match(file_name, /\.sh$/)) next
#			print "cat \x22"CMDCLICK_APP_DIR_PATH"/"file_name"\x22"
#		}'
#	)
#	local change_dir_path=$(\
#		bash -c "${change_dir_path_con}" \
#		| fetch_parameter_from_pip "${CH_DIR_PATH}" \
#		| sed -e 's/$HOME/'${sed_home}'/' \
#			-e 's/${HOME}/'${sed_home}'/' \
#			-e 's/^"//' \
#			-e 's/"$//' \
#	)
#	echo "${change_dir_path}"  > "${CMDCLICK_APP_LIST_PATH}"
#	}
