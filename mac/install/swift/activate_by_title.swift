import AppKit

// 1. コマンドライン引数のチェック
let arguments = CommandLine.arguments
guard arguments.count > 1 else {
    print("エラー: 引数（ウィンドウのタイトル名）を指定してください。")
    print("使用例: ./activate_by_title \"YouTube\"")
    exit(1)
}

// 第1引数をターゲット文字列として取得
let targetTitle = arguments[1]

// 2. 画面上の全ウィンドウから対象を検索
let options = CGWindowListOption([.optionOnScreenOnly, .excludeDesktopElements])
guard let windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] else {
    print("ウィンドウリストの取得に失敗しました。")
    exit(1)
}

var foundPID: pid_t? = nil

for window in windowList {
    guard let layer = window[kCGWindowLayer as String] as? Int, layer == 0 else { continue }
    let ownerName = window[kCGWindowOwnerName as String] as? String ?? ""
    let windowName = window[kCGWindowName as String] as? String ?? ""
    
    // Google Chromeかつ、指定した文字列がウィンドウタイトルに含まれる場合
    if ownerName == "Google Chrome" && windowName.localizedCaseInsensitiveContains(targetTitle) {
        if let pid = window[kCGWindowOwnerPID as String] as? pid_t {
            foundPID = pid
            break
        }
    }
}

// 3. 対象プロセスの最前面化とウィンドウの引き上げ
if let pid = foundPID, let app = NSWorkspace.shared.runningApplications.first(where: { $0.processIdentifier == pid }) {
    // まずアプリ自体をアクティブにする
    app.activate(options: [.activateIgnoringOtherApps])
    
    // AppleScriptを使って、該当タイトルを持つウィンドウを一番前（index 1）に引き上げる
    let scriptSource = """
    tell application "Google Chrome"
        set foundWindow to missing value
        repeat with w in windows
            if title of w contains "\(targetTitle)" then
                set foundWindow to w
                exit repeat
            end if
        end repeat
        if foundWindow is not missing value then
            set index of foundWindow to 1
        end if
    end tell
    """
    
    if let appleScript = NSAppleScript(source: scriptSource) {
        var error: NSDictionary?
        appleScript.executeAndReturnError(&error)
    }
    print("✓ '\(targetTitle)' を含むChromeウィンドウを最前面に出しました。")
} else {
    print("× '\(targetTitle)' を含むChromeのウィンドウが見つかりませんでした。")
}
