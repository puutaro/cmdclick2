#!/usr/bin/env bash

### LABELING_SECTION_START
### LABELING_SECTION_END


### SETTING_SECTION_START
terminalDo=ON
openWhere=CW
terminalFocus=OFF
editExecute=NO
setVariableTypes=
beforeCommand=
afterCommand=
execBeforeCtrlCmd=
execAfterCtrlCmd=
appIconPath=
scriptFileName=build_install_fastpaste.sh
### SETTING_SECTION_END


### CMD_VARIABLE_SECTION_START
### CMD_VARIABLE_SECTION_END


### Please write bellow with shell script

cat << 'EOF' > /tmp/fastpaste.swift
import Cocoa
import CoreGraphics

let args = CommandLine.arguments
guard args.count > 1 else { exit(1) }

let toAppName = args[1]
let enterCount = args.count > 2 ? (Int(args[2]) ?? 1) : 1

for app in NSWorkspace.shared.runningApplications {
    if app.localizedName == toAppName {
        // macOS 14.0 以降推奨の書き方（引数なし）
        app.activate()
        break
    }
}

// アプリのウィンドウアクティブ化を待つ (50ms)
// usleep(50000)

let source = CGEventSource(stateID: .hidSystemState)

// --- Cmd + V (貼り付け) ---
let cmdVDown = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: true)
cmdVDown?.flags = .maskCommand
let cmdVUp = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false)
cmdVUp?.flags = .maskCommand

cmdVDown?.post(tap: .cghidEventTap)
cmdVUp?.post(tap: .cghidEventTap)

// アプリ側で貼り付けが処理される時間を確保 (100ms待機)
usleep(30000)

// --- Return キーの送信 ---
for _ in 0..<enterCount {
    let returnDown = CGEvent(keyboardEventSource: source, virtualKey: 0x24, keyDown: true)
    let returnUp = CGEvent(keyboardEventSource: source, virtualKey: 0x24, keyDown: false)
    
    // 修飾キーをクリア（Cmdキーが残らないようにする）
    returnDown?.flags = []
    returnUp?.flags = []

    returnDown?.post(tap: .cghidEventTap)
    returnUp?.post(tap: .cghidEventTap)

    // 連打時の間隔を確保 (50ms待機)
    usleep(20000)
}
EOF

# 高速化オプション(-O)をつけてコンパイル
swiftc -O /tmp/fastpaste.swift -o /tmp/fastpaste

# /usr/local/bin へ配置
sudo cp -f /tmp/fastpaste /usr/local/bin/fastpaste
sudo chmod +x /usr/local/bin/fastpaste

# クリーンアップ
rm -f /tmp/fastpaste.swift /tmp/fastpaste
