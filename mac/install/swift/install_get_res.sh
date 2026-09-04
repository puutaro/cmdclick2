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
scriptFileName=install_get_res.sh
### SETTING_SECTION_END


### CMD_VARIABLE_SECTION_START
### CMD_VARIABLE_SECTION_END


### Please write bellow with shell script

tmp_path="/tmp"
swift_path="${tmp_path}/get_res.swift"

cat << 'EOF' > "${swift_path}"
import ApplicationServices

if let mainDisplayId = CGMainDisplayID() as CGDirectDisplayID? {
    let width = CGDisplayPixelsWide(mainDisplayId)
    let height = CGDisplayPixelsHigh(mainDisplayId)
    print("\(width) \(height)")
}
EOF
build_and_install(){
    local binary_name="$(basename "${swift_path}" | sed 's/\.swift$//')"
    local build_path="${tmp_path}/${binary_name}"
    local install_path="/usr/local/bin/${binary_name}"
    swiftc -O "${swift_path}" -o "${build_path}"
    sudo cp -v \
        "${build_path}" \
        "${install_path}"
    sudo rm -f "${swift_path}" "${build_path}"
}
build_and_install