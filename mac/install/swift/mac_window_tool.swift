import Foundation
import CoreGraphics
import AppKit

// ==============================================================================
// メイン処理 (CommandLine 引数のパースと実行)
// ==============================================================================

let args = CommandLine.arguments

// ヘルプメッセージ
func printHelp() {
    print("""
    【使用方法】
      -l         : 画面上の全ウィンドウの「バンドルIDリスト」を出力
      -lx        : 画面上の全ウィンドウの「タイトル名一覧」を出力
      -a [引数]   : 指定した「バンドルID」または「アプリ名」を最前面に出す
      -i         : 互換性のためのオプション（他のフラグと併用可能）
    """)
}

// 画面収録の権限チェック
func checkScreenRecordingPermission() -> Bool {
    if #available(macOS 10.15, *) {
        return CGPreflightScreenCaptureAccess()
    }
    return true
}

// 引数がない場合はヘルプを表示して終了
guard args.count > 1 else {
    printHelp()
    exit(0)
}

// フラグの判定用変数
var isList = false
var isWindowList = false
var activateTarget: String? = nil

// 引数を順番にチェック
var i = 1
while i < args.count {
    let arg = args[i]
    
    switch arg {
    case "-i":
        break
        
    case "-l":
        isList = true
        
    case "-lx":
        isWindowList = true
        
    case "-a":
        if i + 1 < args.count {
            activateTarget = args[i + 1]
            i += 1
        } else {
            print("エラー: -a の後ろに対象を指定してください。")
            exit(1)
        }
        
    default:
        printHelp()
        exit(1)
    }
    i += 1
}

// --- 実際の処理を実行 ---

if isList || isWindowList {
    
    if !checkScreenRecordingPermission() {
        print("【警告】macOSの「システム設定 ＞ プライバシーとセキュリティ ＞ 画面＆システムオーディオの録画」で")
        print("ターミナルへの権限を許可してください。")
        if #available(macOS 10.15, *) {
            let _ = CGRequestScreenCaptureAccess()
        }
    }
    
    // オプションを最適化（画面上の全ウィンドウを取得）
    let options: CGWindowListOption = [.optionOnScreenOnly, .excludeDesktopElements]
    if let windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] {
        
        print(String(repeating: "-", count: 90))
        if isList {
            let col1 = "所有アプリ".padding(toLength: 25, withPad: " ", startingAt: 0)
            let col2 = "PID".padding(toLength: 8, withPad: " ", startingAt: 0)
            print("\(col1) | \(col2) | バンドルID")
        } else {
            let col1 = "所有アプリ".padding(toLength: 25, withPad: " ", startingAt: 0)
            let col2 = "PID".padding(toLength: 8, withPad: " ", startingAt: 0)
            print("\(col1) | \(col2) | ウィンドウタイトル")
        }
        print(String(repeating: "-", count: 90))
        
        // 重複出力を防ぐためのセット
        var seenWindows = Set<String>()
        
        for window in windowList {
            // 【重要】レイヤー条件を 0 のみから「5以下」に緩和（通常のアプリウインドウを網羅）
            guard let layer = window[kCGWindowLayer as String] as? Int, layer <= 5 else { continue }
            
            let ownerName = window[kCGWindowOwnerName as String] as? String ?? "Unknown"
            let pid = window[kCGWindowOwnerPID as String] as? Int ?? 0
            let windowName = window[kCGWindowName as String] as? String ?? ""
            
            // システムの常駐部品や空のアプリ名はスキップ
            if ownerName.isEmpty || ownerName == "Window Server" || ownerName == "Dock" { continue }
            
            let appNamePadded = ownerName.padding(toLength: 25, withPad: " ", startingAt: 0)
            let pidPadded = String(pid).padding(toLength: 8, withPad: " ", startingAt: 0)
            
            if isList {
                let bundleId = NSRunningApplication(processIdentifier: pid_t(pid))?.bundleIdentifier ?? "N/A"
                let uniqueKey = "\(pid)-\(bundleId)"
                
                if !seenWindows.contains(uniqueKey) {
                    print("\(appNamePadded) | \(pidPadded) | \(bundleId)")
                    seenWindows.insert(uniqueKey)
                }
            }
            
            if isWindowList {
                // タイトルが空でない、またはターミナルのようにタイトルを持つものを出力
                let displayTitle = windowName.isEmpty ? "(タイトルなし)" : windowName
                let uniqueKey = "\(pid)-\(displayTitle)"
                
                if !seenWindows.contains(uniqueKey) {
                    print("\(appNamePadded) | \(pidPadded) | \(displayTitle)")
                    seenWindows.insert(uniqueKey)
                }
            }
        }
    }
}

// 2. -a が指定された場合 (最前面化)
if let target = activateTarget {
    let apps = NSWorkspace.shared.runningApplications.filter { $0.activationPolicy == .regular }
    
    if let app = apps.first(where: { 
        ($0.bundleIdentifier?.localizedCaseInsensitiveContains(target) ?? false) ||
        ($0.localizedName?.localizedCaseInsensitiveContains(target) ?? false)
    }) {
        if #available(macOS 14.0, *) {
            app.activate()
        } else {
            app.activate(options: [.activateIgnoringOtherApps])
        }
        print("✓ '\(target)' を最前面に表示しました。")
    } else {
        print("× 指定された対象 '\(target)' が見つからないか、起動していません。")
    }
}

