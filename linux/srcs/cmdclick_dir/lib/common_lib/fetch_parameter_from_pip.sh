#!/usr/bin/env bash


fetch_parameter(){
	local contents="${1}"
	local target_parameter="${2}"
	[ -z "${contents}" ] && return 0
	echo "${contents}" \
	|awk -v target="${target_parameter}=" \
	' BEGIN {
		len = length(target)
	}
	{
    if(index($0, target) != 1) next
    print substr($0, len + 1)
	}
	'
}

fetch_parameter_from_pip(){
	local target_parameter="${1}"
	local hat_target_parameter="^'${target_parameter}'="
	fetch_parameter \
		"$(cat "/dev/stdin")" \
		"${target_parameter}"
}
