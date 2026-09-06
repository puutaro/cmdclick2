import ApplicationServices

if let mainDisplayId = CGMainDisplayID() as CGDirectDisplayID? {
    let width = CGDisplayPixelsWide(mainDisplayId)
    let height = CGDisplayPixelsHigh(mainDisplayId)
    print("\(width)x\(height)")
}
