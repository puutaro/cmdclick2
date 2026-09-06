import Foundation
import IOKit.pwr_mgt

var assertionID: IOPMAssertionID = 0
let success = IOPMAssertionCreateWithName(
    kIOPMAssertionTypeNoDisplaySleep as CFString,
    IOPMAssertionLevel(kIOPMAssertionLevelOn),
    "Prevent Sleep Binary" as CFString,
    &assertionID
)

if success == kIOReturnSuccess {
    print("【動作中】画面ロック・スリープを防止しています。")
    print("終了するには Ctrl + C を押すか、この画面を閉じてください。")
    RunLoop.current.run()
} else {
    print("エラー: スリープ防止の有効化に失敗しました。")
}
