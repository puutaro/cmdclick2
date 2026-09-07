#!/usr/bin/env bash

echo_longpath_by_summraizing(){
	local target_path="${1}"
	local display_path_hierarchy_limit_num=4

	# 1. $HOME を ~ に置換 (先頭にマッチした場合のみ置換)
	if [[ "${target_path}" == "${HOME}"* ]]; then
		target_path="~${target_path#"${HOME}"}"
	fi

	# 2. パスをスラッシュ / で分解して配列に格納 (空要素を除外するため shopt 設定)
	local target_path_list
	IFS='/' read -r -a target_path_list <<< "${target_path}"

	# 階層数 (配列の要素数) を取得
	local target_path_list_length="${#target_path_list[@]}"

	# 階層数が制限以下の場合はそのまま出力
	if [ "${target_path_list_length}" -le "${display_path_hierarchy_limit_num}" ]; then
		echo "${target_path}"
		return 0
	fi

	# 3. 制限を超えている場合: target_path_list[1] /../ 後半2つ を結合
	# (インデックス: 0は先頭の空要素、1は最初の要素、長さ-2 は後ろから2番目の要素)
	local first_elem="${target_path_list[0]}"
	# パスが絶対パス（/で始まる）か相対パス（~で始まる）かで最初の要素を取得
	if [ -z "${first_elem}" ] && [ "${target_path_list_length}" -gt 1 ]; then
		first_elem="${target_path_list[1]}"
	fi

	local prev_last_elem="${target_path_list[$((target_path_list_length - 2))]}"
	local last_elem="${target_path_list[$((target_path_list_length - 1))]}"

	echo "${first_elem}/../${prev_last_elem}/${last_elem}"
}
#echo_longpath_by_summraizing(){
#	local path="${1}"
#	local display_path_hierarchy_limit_num=4
#	echo "${path}" \
#		| awk \
#		-v HOME="${HOME}" \
#		-v display_path_hierarchy_limit_num=${display_path_hierarchy_limit_num} \
#		'{
#			target_path = $0
#			gsub(HOME, "~", target_path)
#			target_path_list_length = split(\
#				target_path, \
#				target_path_list, \
#				"/" \
#			)
#			if(target_path_list_length <= display_path_hierarchy_limit_num){
#				print target_path
#				exit
#			}
#			print target_path_list[1]"/../"target_path_list[target_path_list_length-1]"/"target_path_list[target_path_list_length]
#		}'
#}
