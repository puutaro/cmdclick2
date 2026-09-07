#!/usr/bin/env bash

echo_ini_file_list(){
	local ini_file_dir_path="${1}"
	local display_ini_file_dir_path="${2}"

	# [ヘッダー] の出力
	echo "[${display_ini_file_dir_path}]"

	local file_name
	local display_count=0

	# ls -1t で更新日時順にファイル名（またはパス）だけを高速取得
	while IFS= read -r file_name; do
		# *.sh 以外（またはファイルが存在しない場合）はスキップ
		[[ "${file_name}" == *.sh ]] || continue

		# 末尾の * を削除 (ls -F 対策)
		file_name="${file_name%\*}"

		echo -e "${file_name}\t${ini_file_dir_path}"
		display_count=$((display_count + 1))
	done < <(ls -1t "${ini_file_dir_path}" 2>/dev/null)

	# 1件もヒットしなかった場合
	if [ "${display_count}" -eq 0 ]; then
		echo -e "-\t${ini_file_dir_path}"
	fi
}
#echo_ini_file_list(){
#	local ini_file_dir_path="${1}"
#	local display_ini_file_dir_path="${2}"
#	ls -tl "${ini_file_dir_path}" \
#	| awk \
#		-v ini_file_dir_path="${ini_file_dir_path}" \
#		-v display_ini_file_dir_path="${display_ini_file_dir_path}" \
#		'
#		BEGIN {
#			print "["display_ini_file_dir_path"]"
#			display_count = 0
#		}
#		{
#			nine_field_later_str=substr($0, index($0, $9), length($0))
#			gsub(/\*$/, "", nine_field_later_str)
#			if(!match(nine_field_later_str, /\.sh$/)) next
#			print nine_field_later_str"\t"ini_file_dir_path
#			display_count++
#		}
#		END {
#			if(!display_count) print "-\t"ini_file_dir_path
#		}'
#}
