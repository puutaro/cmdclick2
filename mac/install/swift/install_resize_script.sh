#!/bin/bash

### SETTING_SECTION_START
terminalDo=ON
openWhere=CW
terminal_size=MAX
terminalFocus=OFF
editExecute=N
in_exe_dflt_vl=
beforeCommand=
afterCommand=
scriptFileName=install_resize_script.sh
### SETTING_SECTION_END


### CMD_VARIABLE_SECTION_START
### CMD_VARIABLE_SECTION_END


### Please write bellow with shell script

sudo cp resize.scpt /usr/local/bin/
sudo tee /usr/local/bin/resize << 'EOF'
#!/bin/bash
osascript /usr/local/bin/resize.scpt "$@"
EOF
sudo chmod +x /usr/local/bin/resize
