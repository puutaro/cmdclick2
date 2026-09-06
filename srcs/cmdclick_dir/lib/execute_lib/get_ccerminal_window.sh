#!/usr/bin/env bash


get_ccerminal_window(){
  if [ "${CMDCLICK_OS}" = "Darwin" ];then
    ccerminal_window_list="${PASTE_TARGET_TERMINAL_NAME}"
    return
  fi
	ccerminal_window_list=$(\
		get_by_window_title \
			"${PASTE_TARGET_TERMINAL_NAME}" \
	)
	case "${ccerminal_window_list}" in 
		"") ;; 
		*)  return ;; esac
	ccerminal_window_list=$(get_terminal_window_exclude_command_click_window)
	case "${ccerminal_window_list}" in 
		"") ;; 
		*)  return ;; esac
	bash -c "${terminal_exec_command}"
	sleep 0.5
	ccerminal_window_list=$(get_terminal_window_exclude_command_click_window)
}


get_terminal_window_exclude_command_click_window(){
	wmctrl -lx \
		| awk \
		-v TARGET_TERMINAL_NAME="${PASTE_TARGET_TERMINAL_NAME}" \
		-v WINDOW_TITLE="${WINDOW_TITLE}" \
		'{
			if($0 ~ WINDOW_TITLE) next
			if($0 !~ TARGET_TERMINAL_NAME) next
			last_window_id=$1
		}
		END {
			print last_window_id
		}' 
}