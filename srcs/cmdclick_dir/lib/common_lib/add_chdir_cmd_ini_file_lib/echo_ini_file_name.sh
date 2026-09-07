#!/usr/bin/env bash

echo_ini_file_name(){
	local create_chdir_path="${1}"
	echo "${create_chdir_path}" \
  # 1. 記号 ["`${},~$|] の除去（パターン削除）
  local _path="${create_chdir_path//[\"\"\`\$\{\},\~\$\|]/}"
  # 2. / を _ に変換
  _path="${_path//\//_}"
  # 3. 先頭の _ を削除（sed 's/^\_//' の再現）
  _path="${_path#_}"
  # 4. 'cd_' の付与と拡張子の結合（一発で結合）
  echo "cd_${_path}${COMMAND_CLICK_EXTENSION}"
#		| sed -e 's/["`${},~$\|]//g' \
#			-e 's/\//\_/g' \
#			-e 's/^\_//' \
#			-e 's/^/cd\_/' \
#			-e 's/$/'${COMMAND_CLICK_EXTENSION}'/'
}