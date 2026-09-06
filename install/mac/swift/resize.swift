import AppKit
import ApplicationServices

let args = CommandLine.arguments

guard args.count == 6 else {
    print("Usage: window-resize <AppName> <x1> <y1> <x2> <y2>")
    exit(EXIT_FAILURE)
}

var iterator = args.makeIterator()
let _ = iterator.next()
let appInput = iterator.next() ?? ""
let x1Str = iterator.next() ?? ""
let y1Str = iterator.next() ?? ""
let x2Str = iterator.next() ?? ""
let y2Str = iterator.next() ?? ""

guard let x1 = Double(x1Str), let y1 = Double(y1Str),
      let x2 = Double(x2Str), let y2 = Double(y2Str) else {
    print("Error: Coordinates must be numbers.")
    exit(EXIT_FAILURE)
}
let width = x2 - x1
let height = y2 - y1

// 【解決策】CoreGraphics を使い、セキュリティ制限を受けずに全ウィンドウからPIDを取得
var targetPid: pid_t? = nil
let options = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)

if let windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: AnyObject]] {
    for window in windowList {
        // アプリ名を取得
        if let ownerName = window[kCGWindowOwnerName as String] as? String {
            // 前方一致/部分一致/完全一致のいずれかでチェック
            if ownerName.localizedCaseInsensitiveContains(appInput) {
                if let pid = window[kCGWindowOwnerPID as String] as? pid_t {
                    targetPid = pid
                    break // 最前面に開かれているウィンドウを持つPIDを採用
                }
            }
        }
    }
}

guard let pid = targetPid else {
    print("Error: Application '\(appInput)' not found or not running.")
    exit(EXIT_FAILURE)
}

// 2. 取得したPIDを使ってAccessibility APIで直接ウィンドウをリサイズ（爆速）
let appRef = AXUIElementCreateApplication(pid)
var frontWindowRef: AnyObject?

// メインウィンドウ、またはフォーカスされているウィンドウを取得
let result = AXUIElementCopyAttributeValue(appRef, kAXMainWindowAttribute as CFString, &frontWindowRef)
guard result == .success, let windowRef = frontWindowRef as! AXUIElement? else {
    let resultFocus = AXUIElementCopyAttributeValue(appRef, kAXFocusedWindowAttribute as CFString, &frontWindowRef)
    guard resultFocus == .success, let windowRefFallback = frontWindowRef as! AXUIElement? else {
        print("Error: Could not find the window. Please grant 'Accessibility' permission to Terminal in System Settings.")
        exit(EXIT_FAILURE)
    }
    setWindow(windowRefFallback, x1: x1, y1: y1, w: width, h: height)
    exit(EXIT_SUCCESS)
}

setWindow(windowRef, x1: x1, y1: y1, w: width, h: height)
print("Success: Resized '\(appInput)' via CoreGraphics & Accessibility API.")

func setWindow(_ windowRef: AXUIElement, x1: Double, y1: Double, w: Double, h: Double) {
    var position = CGPoint(x: x1, y: y1)
    if let posVal = AXValueCreate(AXValueType(rawValue: kAXValueCGPointType)!, &position) {
        AXUIElementSetAttributeValue(windowRef, kAXPositionAttribute as CFString, posVal)
    }
    var size = CGSize(width: w, height: h)
    if let sizeVal = AXValueCreate(AXValueType(rawValue: kAXValueCGSizeType)!, &size) {
        AXUIElementSetAttributeValue(windowRef, kAXSizeAttribute as CFString, sizeVal)
    }
}
