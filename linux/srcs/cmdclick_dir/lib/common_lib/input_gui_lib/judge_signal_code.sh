#!/bin/bash


judge_signal_code(){
	local return_status="${1}"
	if ! expr "${return_status}" + 1 : "[0-9]*$" >&/dev/null; then
		echo "${EXIT_CODE}"
		return
	fi 
	case "${return_status}" in 
		"${OK_CODE}")
		  echo ${OK_CODE}
		  return;;
		"${EDIT_CODE}")
		  echo ${EDIT_CODE}
		  return;;
		"${DESCRIPTION_EDIT_CODE}")
		  echo ${DESCRIPTION_EDIT_CODE}
		  return;;
		"${ADD_CODE}")
		  echo ${ADD_CODE}
		  return;;
		"${CHDIR_CODE}")
		  echo ${CHDIR_CODE}
		  return;;
		"${RESOLUTION_CODE:-}")
		  echo ${RESOLUTION_CODE}
		  return;;
		"${DELETE_CODE}")
		  echo ${DELETE_CODE}
		  return;;
		"${MOVE_CODE}")
		  echo ${MOVE_CODE}
		  return;;
		"${INSTALL_CODE}")
		  echo ${INSTALL_CODE}
		  return;;
		"${SETTING_CODE}")
		  echo ${SETTING_CODE}
		  return;;
	esac
  echo ${EXIT_CODE}
}