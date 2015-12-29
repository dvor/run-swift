import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    let window = NSWindow()
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        print("applicationDidFinishLaunching")
        exit(0)
    }
}
