#!/usr/bin/env bash

readonly launcher_cmd_index_by_lxterminal_lib_dir_path="$(dirname ${0})"
readonly input_gui_lib_dir_path="$(dirname ${launcher_cmd_index_by_lxterminal_lib_dir_path})"
readonly common_lib_dir_path="$(dirname ${input_gui_lib_dir_path})"
readonly lib_dir_path="$(dirname ${common_lib_dir_path})"
readonly cmdclick_dir_path="$(dirname ${lib_dir_path})"
export IMPORT_PATH_EXEC_CMDCLICK="${cmdclick_dir_path}/exec_cmdclick.sh"
export IMPORT_PATH_INPUT_GUI="${common_lib_dir_path}/input_gui.sh"
readonly main_list_lib_dir_path="${launcher_cmd_index_by_lxterminal_lib_dir_path}/main_list_lib"
readonly IMPORT_CMDCLICK_VAL=1
. "${IMPORT_PATH_EXEC_CMDCLICK}"
. "${main_list_lib_dir_path}/normal_index.sh"
. "${main_list_lib_dir_path}/app_dir_setting_index.sh"
. "${main_list_lib_dir_path}/jfold.sh"
export -f jfold

main_list(){
    LANG="ja_JP.UTF-8"
    local ifs_local="${IFS}"
    local IFS=$'\t' 
    local ini_file_dir_path="${1}"
    local ini_file_list="${2}"
    local scale_display_width="${3}"
    case "${ini_file_dir_path}" in 
        "${CMDCLICK_APP_DIR_PATH}")
            read -r -a VALUE < <(
                app_dir_setting_index \
                    "${ini_file_list}" \
                    "${scale_display_width}"
                )
            ;;
        *)
            read -r -a VALUE < <(
              echo "${ini_file_list}" | \
              webdi --delimiter $'\t' \
                --window-icon "${CMDCLICK_WINDOW_ICON_PATH}" \
                --with-nth 1 \
                --cycle \
                --header-lines=1 \
                --id=${CMDCLICK_MACHINE_ID} \
                --execute "w:open_editor {2}/{1}" \
                --execute "v:execute(echo {2}/{1} | tr -d '\n' | xclip -selection c -i -f)" \
                --exec-quit "e:echo \"${EDIT_CODE},{1},{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}')" \
                --exec-quit "k:echo \"${DESCRIPTION_EDIT_CODE},{1},{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}')" \
                --exec-quit "m:echo \"${MOVE_CODE},{1},{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}')" \
                --exec-quit "i:echo \"${INSTALL_CODE},{1},{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}')" \
                --exec-quit "q:echo \"${ADD_CODE},{1},{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}')" \
                --exec-quit "d:echo \"${DELETE_CODE},{1},{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}')" \
                --exec-quit "c:echo \"${CHDIR_CODE},{1},${CMDCLICK_APP_DIR_PATH}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}')" \
                --exec-quit "p:echo \"${SETTING_CODE},{1},{2}\" > '${CMDCLICK_VALUE_SIGNAL_FILE_PATH}')" \
                --reload "s:export IMPORT_CMDCLICK_VAL=1 && . ${IMPORT_PATH_EXEC_CMDCLICK} && . ${IMPORT_PATH_INPUT_GUI} && export SIGNAL_CODE=${SIGNAL_CODE} && exec_inc && reload_cmd)" \
                --reload "a:export IMPORT_CMDCLICK_VAL=1 && . ${IMPORT_PATH_EXEC_CMDCLICK} && . ${IMPORT_PATH_INPUT_GUI} && export SIGNAL_CODE=${SIGNAL_CODE} && exec_dec && reload_cmd)" \
                --reload "r:export IMPORT_CMDCLICK_VAL=1 && . ${IMPORT_PATH_EXEC_CMDCLICK} && . ${IMPORT_PATH_INPUT_GUI} && export SIGNAL_CODE=${SIGNAL_CODE} && reload_cmd)" \
            )

#
#            read -r -a VALUE < <(
#                normal_index \
#                    "${ini_file_list}" \
#                    "${scale_display_width}"
#                )
        ;;
    esac
    IFS="${ifs_local}"
    case "${VALUE[0]}" in
        "") return ;; esac
    echo "${OK_CODE},${VALUE[0]},${VALUE[1]}" \
        > "${CMDCLICK_VALUE_SIGNAL_FILE_PATH}"
}

ini_file_dir_path="${1}"
ini_file_list="${2}"
scale_display_width="${3}"
main_list \
    "${ini_file_dir_path}" \
    "${ini_file_list}" \
    "${scale_display_width}"

unset -v ini_file_dir_path
unet -v ini_file_list
unset -v scale_display_width