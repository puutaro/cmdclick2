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
