#!/bin/bash



launcher_cmd_index_by_lxterminal(){
	local LANG="ja_JP.UTF-8"
	local ini_file_dir_path=${1}
	local ini_file_list=${2}
	local x_position=${3}
	local y_position=${4}
	local scale_display_width=${5}
	local scale_display_height="${6}"
	local hiddenOption="${7}"
	local main_list_sh_path=${COMMON_LIB_DIR_PATH}/input_gui_lib/launcher_cmd_index_by_lxterminal_lib/main_list.sh
#	[ -f "${HOME}/.fzf.bash" ] && . ${HOME}/.fzf.bash
  local line=""
  local exit_status=${EXIT_CODE}
  case "${ini_file_dir_path}" in
      "${CMDCLICK_APP_DIR_PATH}")
          line=$(
              echo "${ini_file_list}" | \
                  guigui \
                    list \
                    --title="${WINDOW_TITLE}" \
                    --window-icon "${CMDCLICK_WINDOW_ICON_PATH}" \
                    --delimiter $'\t' \
                    --with-nth 1 \
                    ${hiddenOption} \
                    --cycle \
                    --x ${x_position} \
                    --y ${y_position} \
                    --width "${scale_display_width}" \
                    --height "${scale_display_height}" \
                    --font-size ${CMDCLICK_LIST_FONT_SIZE} \
                    --borders=${CMDCLICK_LIST_PADDING} \
                    --header-lines=1 \
                    --id=${CMDCLICK_MACHINE_ID} \
                    --execute "w:execute(open_editor {2}/{1})" \
                    --exec-quit "e:${EXIT_CODE}:echo -e \"{1}\t{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}'" \
                    --exec-quit "k:${DESCRIPTION_EDIT_CODE}:echo -e \"{1}\t{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}'" \
                    --exec-quit "q:${ADD_CODE}:echo -e \"{1}\t{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}'" \
                    --exec-quit "d:${DELETE_CODE}:echo -e \"{1}\t{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}'" \
          )
          exit_status=$?
          echo "${exit_status}" >&2
          ;;
      *)
        export IMPORT_PATH_EXEC_CMDCLICK="${0}"
        export IMPORT_PATH_INPUT_GUI="$(dirname "${IMPORT_PATH_EXEC_CMDCLICK}")/lib/common_lib/input_gui.sh"
        line=$(
          echo "${ini_file_list}" \
          | guigui \
            list \
            --window-icon "${CMDCLICK_WINDOW_ICON_PATH}" \
            --title="${WINDOW_TITLE}" \
            --delimiter $'\t' \
            --header-lines=1 \
            --with-nth 1 \
            ${hiddenOption} \
            --x ${x_position} \
            --y ${y_position} \
            --width "${scale_display_width}" \
            --height "${scale_display_height}" \
            --font-size ${CMDCLICK_LIST_FONT_SIZE} \
            --borders=${CMDCLICK_LIST_PADDING} \
            --cycle \
            --id=${CMDCLICK_MACHINE_ID} \
            --execute "w:open_editor {2}/{1}" \
            --execute "v:echo {2}/{1} | tr -d '\n' | xclip -selection c -i -f" \
            --exec-quit "e:${EDIT_CODE}:echo -e \"{1}\t{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}'" \
            --exec-quit "k:${DESCRIPTION_EDIT_CODE}:echo -e \"{1}\t{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}'" \
            --exec-quit "m:${MOVE_CODE}:echo -e \"{1}\t{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}'" \
            --exec-quit "i:${INSTALL_CODE}:echo -e \"{1}\t{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}'" \
            --exec-quit "q:${ADD_CODE}:echo -e \"{1}\t{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}'" \
            --exec-quit "d:${DELETE_CODE}:echo -e \"{1}\t{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}'" \
            --exec-quit "c:${CHDIR_CODE}:echo -e \"{1}\t${CMDCLICK_APP_DIR_PATH}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}'" \
            --exec-quit "p:${SETTING_CODE}:echo -e \"{1}\t{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}'" \
            --reload "s:export IMPORT_CMDCLICK_VAL=1 && . ${IMPORT_PATH_EXEC_CMDCLICK} && . ${IMPORT_PATH_INPUT_GUI} && exec_inc && reload_cmd" \
            --reload "a:export IMPORT_CMDCLICK_VAL=1 && . ${IMPORT_PATH_EXEC_CMDCLICK} && . ${IMPORT_PATH_INPUT_GUI} && exec_dec && reload_cmd" \
            --reload "r:export IMPORT_CMDCLICK_VAL=1 && . ${IMPORT_PATH_EXEC_CMDCLICK} && . ${IMPORT_PATH_INPUT_GUI} && reload_cmd" \
        )
        exit_status=$?
      ;;
  esac
  case "${line}" in
    "") ;;
    *) echo "${line}" > ${CMDCLICK_VALUE_SIGNAL_FILE_PATH}
      ;;
  esac
  return ${exit_status}
}