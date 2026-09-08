#!/usr/bin/env bash


add_cmd_base="webdi form \
    --title=\"\${WINDOW_TITLE}\" \
    --keep \
    --window-icon=\"\${WINDOW_ICON_PATH}\" \
    --item-separator='!'\
    --center \
    --scroll \
    --font-size=\${CMDCLICK_FORM_FONT_SIZE} \
    --borders=\${CMDCLICK_FORM_PADDING} \
    --height=\${CENTER_SCALE_DISPLAY_HEIGHT} \
    --width=\${CENTER_SCALE_DISPLAY_WIDTH} \
    --id=\${CMDCLICK_MACHINE_ID} \
    "