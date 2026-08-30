#!/bin/bash


delete_confirm_form_cmd="guigui form \
    --title=\"\${WINDOW_TITLE}\" \
    --window-icon=\"\${WINDOW_ICON_PATH}\" \
    --item-separator='!'\
    --center \
    --scroll \
    --font-size=\${CMDCLICK_FORM_FONT_SIZE} \
    --borders=\${CMDCLICK_FORM_PADDING} \
    --height=\${scale_display_height} \
    --id=\${CMDCLICK_MACHINE_ID} \
    --width=\${scale_display_width}"
