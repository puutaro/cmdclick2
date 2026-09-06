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
scriptFileName=install_check_window.sh
### SETTING_SECTION_END


### CMD_VARIABLE_SECTION_START
### CMD_VARIABLE_SECTION_END


### Please write bellow with shell script

# ⚠️ 古い壊れたファイルを確実に削除する（これが最重要です）
rm -f check_window.swift check_window

# 新しい正しいSwiftコードを書き出す
cat << 'EOF' > check_window.swift
import Cocoa

let arguments = CommandLine.arguments
guard arguments.count > 1 else {
    print("false")
    exit(1)
}
let searchTitle = arguments[1]

// 画面上にあるすべてのウィンドウ情報を一瞬で取得
let options = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)
guard let windowListInfo = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] else {
    print("false")
    exit(1)
}

var found = ""
for info in windowListInfo {
    if let windowName = info[kCGWindowName as String] as? String {
        // 部分一致で判定
        if windowName.contains(searchTitle) {
            found = windowName
            break
        }
    }
}

print(found)
EOF

# コンパイルを実行
swiftc -O check_window.swift -o check_window

# /usr/local/bin/ へコピー（パスワードを求められたら入力してください）
sudo cp -v check_window /usr/local/bin/
