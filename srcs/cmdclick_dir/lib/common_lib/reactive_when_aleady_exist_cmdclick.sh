#!/usr/bin/env bash


reactive_when_aleady_exist_cmdclick(){
	case "${ACTIVE_CHECK_VARIABLE}" in
		"0");; *) return ;; esac
			ACTIVE_CHECK_VARIABLE=1
  if [ "${CMDCLICK_OS}" = "Darwin" ];then
      webdi \
        window \
        --show \
        --id "${CMDCLICK_MACHINE_ID}"
  fi
  local cmdclick_proc_without_no_gui=""
  if [ "${CMDCLICK_OS}" = "Darwin" ];then
    cmdclick_proc_without_no_gui=$(
      check_window "${WINDOW_TITLE}"
      )
  else
    cmdclick_proc_without_no_gui=$(
      ps aux | awk -v mid="$CMDCLICK_MACHINE_ID" '
          ($0 ~ /webdi/) &&
          ($0 ~ /cmdclick/) &&
          ($0 ~ mid) &&
          ($0 !~ /--gui-mode/)
      ')
  fi
  case "${cmdclick_proc_without_no_gui}" in
    "") return;;
  esac
  if [ "${CMDCLICK_OS}" = "Darwin" ] \
    && [ -n "${cmdclick_proc_without_no_gui}" ];then
     exit 0
  fi
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

# super slow so, no use
activete_by_appscript(){
  osascript - "$1" << 'EOF'
  on run argv
      set targetName to item 1 of argv

      tell application "System Events"
          -- 1. まずアプリ名またはプロセス名として一致するものがあれば前面へ
          try
              set targetProc to (first application process whose name is targetName or name contains targetName)
              set frontmost of targetProc to true
              return
          end try

          -- 2. アプリ名で見つからない場合、全プロセスの「ウィンドウタイトル」を走査して一致するものを前面へ
          repeat with proc in (every application process whose background only is false)
              try
                  tell proc
                      repeat with w in (every window)
                          if (name of w) contains targetName then
                              set frontmost of proc to true
                              perform action "AXRaise" of w
                              return
                          end if
                      end repeat
                  end tell
              end try
          end repeat
      end tell
  end run
EOF
}