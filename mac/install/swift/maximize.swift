import Cocoa
import ApplicationServices

func maximizeFrontmostWindowPure() {
    // 1. 最前面のアクティブなアプリ（プロセス）を取得
    guard let frontmostApp = NSWorkspace.shared.frontmostApplication else {
        print("最前面のアプリを取得できませんでした。")
        return
    }
    
    let pid = frontmostApp.processIdentifier
    let appElement = AXUIElementCreateApplication(pid)
    
    // 2. アプリの「メインウィンドウ」を取得
    var mainWindowRef: AnyObject?
    let windowResult = AXUIElementCopyAttributeValue(appElement, kAXMainWindowAttribute as CFString, &mainWindowRef)
    
    guard windowResult == .success, let windowElement = mainWindowRef as! AXUIElement? else {
        print("\(frontmostApp.localizedName ?? "アプリ") にアクティブなウィンドウが見つかりません。")
        return
    }
    
    // 3. 【追加】全画面表示（フルスクリーン）されている場合は、まず解除する
    var isFullscreenRef: AnyObject?
    let fullscreenAttribute = "AXFullScreen" as CFString
    AXUIElementCopyAttributeValue(windowElement, fullscreenAttribute, &isFullscreenRef)
    
    if let isFullscreen = isFullscreenRef as? Bool, isFullscreen == true {
        print("全画面表示を検知。解除してから最大化します...")
        // 全画面表示を解除
        AXUIElementSetAttributeValue(windowElement, fullscreenAttribute, false as CFTypeRef)
        // macOSの全画面解除アニメーション（デスクトップの切り替え）が完了するのを少し待つ
        Thread.sleep(forTimeInterval: 0.6)
    }
    
    // 4. 現在のマウスカーソルがあるディスプレイ（またはメインディスプレイ）の「有効な領域」を取得
    // ※メニューバーやDockのサイズを自動で除外した領域（visibleFrame）になります
    guard let targetScreen = NSScreen.main else {
        print("ディスプレイ情報を取得できませんでした。")
        return
    }
    let visibleFrame = targetScreen.visibleFrame
    
    // 5. ディスプレイの座標系をAccessibilityの座標系（左上が原点0,0）に変換
    // macOSのNSScreenは左下が原点ですが、AXUIElementは左上が原点のため計算が必要です
    let screenHeight = targetScreen.frame.size.height
    let targetX = visibleFrame.origin.x
    let targetY = screenHeight - visibleFrame.origin.y - visibleFrame.size.height
    let targetWidth = visibleFrame.size.width
    let targetHeight = visibleFrame.size.height
    
    // 6. ウィンドウの位置（Position）を左上に移動
    var newPoint = CGPoint(x: targetX, y: targetY)
    if let positionValue = AXValueCreate(.cgPoint, &newPoint) {
        AXUIElementSetAttributeValue(windowElement, kAXPositionAttribute as CFString, positionValue)
    }
    
    // 7. ウィンドウのサイズ（Size）をディスプレイの最大サイズに変更
    var newSize = CGSize(width: targetWidth, height: targetHeight)
    if let sizeValue = AXValueCreate(.cgSize, &newSize) {
        AXUIElementSetAttributeValue(windowElement, kAXSizeAttribute as CFString, sizeValue)
    }
    
    print("\(frontmostApp.localizedName ?? "アプリ") をメニューバーを残して最大化しました。")
}

// 実行
maximizeFrontmostWindowPure()
