#!/bin/bash


reactive_when_aleady_exist_cmdclick(){
	case "${ACTIVE_CHECK_VARIABLE}" in 
		"0");; *) return ;; esac
			ACTIVE_CHECK_VARIABLE=1
  local cmdclick_proc_without_no_gui=$(
    ps aux | awk -v mid="$CMDCLICK_MACHINE_ID" '
        ($0 ~ /guigui/) &&
        ($0 ~ /cmdclick/) &&
        ($0 ~ mid) &&
        ($0 !~ /--gui-mode/)
    ')
  case "${cmdclick_proc_without_no_gui}" in
    "") return;;
  esac
	local reacctive_check=$(\
		wmctrl -l \
		| grep "${WINDOW_TITLE}" \
		|| e=$? \
	)
	case "${reacctive_check}" in 
		"") return ;; esac 
	wmctrl -a "${WINDOW_TITLE}"
	exit 0
}