import AppKit

// 起動中のアプリからGoogle Chromeを探す
if let chrome = NSWorkspace.shared.runningApplications.first(where: { $0.bundleIdentifier == "com.google.Chrome" }) {
    // 最前面に引っ張り出す
    chrome.activate(options: [.activateIgnoringOtherApps])
} else {
    // 起動していなければ新しく開く
    NSWorkspace.shared.launchApplication("Google Chrome")
}
