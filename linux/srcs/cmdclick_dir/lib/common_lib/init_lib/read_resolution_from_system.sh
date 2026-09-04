#!/usr/bin/env bash


read_resolution_from_system(){
	local ifs_old=${IFS}
	local IFS=$' '
	DISPLAY_RSOLUTION_LIST=""
  if [ "${CMDCLICK_OS}" = "Darwin" ];then
    DISPLAY_RSOLUTION_LIST=(\
      $(\
        get_res || e=$? \
      ) \
    )
  else
    DISPLAY_RSOLUTION_LIST=(\
      $(\
        xrandr \
            | awk '{
                if($0 !~ /\*/) next
                gsub(/x/, " ", $1)
                print $1
                exit
            }' || e=$? \
      ) \
    )
	fi
  readonly DISPLAY_RSOLUTION_LIST
	local IFS="${ifs_old}"
	DISPLAY_RSOLUTION_WIDTH="${DISPLAY_RSOLUTION_LIST[0]}"
	DISPLAY_RSOLUTION_HEIGHT="${DISPLAY_RSOLUTION_LIST[1]}"
	CENTER_SCALE_DISPLAY_HEIGHT="$(echo "scale=0; ${DISPLAY_RSOLUTION_HEIGHT} / 1.1" | bc)"
	CENTER_SCALE_DISPLAY_WIDTH="$(echo "scale=0; ${DISPLAY_RSOLUTION_WIDTH} / 1.9" | bc)"
	local offset=60
	local true_display_resolution_width=$(\
			expr ${DISPLAY_RSOLUTION_WIDTH} - ${offset}\
		)
	local true_display_resolution_height=$(\
			expr ${DISPLAY_RSOLUTION_HEIGHT} - ${offset}\
		)
	CENTER_X_POSITION=$(( $((${true_display_resolution_width} - ${CENTER_SCALE_DISPLAY_WIDTH})) / 2 ))
	CENTER_Y_POSITION=$(( ${true_display_resolution_height} - ${CENTER_SCALE_DISPLAY_HEIGHT} ))

	RIGHT_SCALE_DISPLAY_WIDTH=$(echo "scale=0; ${DISPLAY_RSOLUTION_WIDTH} / 3.0" | bc)
	RIGHT_SCALE_DISPLAY_HEIGHT=$(echo "scale=0; ${DISPLAY_RSOLUTION_HEIGHT} / 1.3" |bc)
	RIGHT_X_POSITION=$(\
		echo "scale=0; \
		${DISPLAY_RSOLUTION_WIDTH} - ${RIGHT_SCALE_DISPLAY_WIDTH}" | bc\
	)
	RIGHT_Y_POSITION=$(echo "scale=0; ( ${DISPLAY_RSOLUTION_HEIGHT} - ${RIGHT_SCALE_DISPLAY_HEIGHT} ) / 2" | bc)
}