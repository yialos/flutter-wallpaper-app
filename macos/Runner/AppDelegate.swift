import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  private let CHANNEL = "com.wallpaperapp/wallpaper"
  
  override func applicationDidFinishLaunching(_ notification: Notification) {
    let controller : FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
    let wallpaperChannel = FlutterMethodChannel(name: CHANNEL,
                                                binaryMessenger: controller.engine.binaryMessenger)
    
    wallpaperChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard let self = self else { return }
      
      switch call.method {
      case "setDesktopWallpaper":
        guard let args = call.arguments as? [String: Any],
              let imagePath = args["imagePath"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENT",
                            message: "Image path is required",
                            details: nil))
          return
        }
        
        self.setDesktopWallpaper(imagePath: imagePath, result: result)
        
      default:
        result(FlutterMethodNotImplemented)
      }
    })
  }
  
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  
  private func setDesktopWallpaper(imagePath: String, result: @escaping FlutterResult) {
    // Check if file exists
    guard FileManager.default.fileExists(atPath: imagePath) else {
      result(FlutterError(code: "FILE_NOT_FOUND",
                        message: "Image file not found",
                        details: nil))
      return
    }
    
    let imageURL = URL(fileURLWithPath: imagePath)
    
    // Get all screens
    guard let screens = NSScreen.screens as? [NSScreen] else {
      result(FlutterError(code: "NO_SCREENS",
                        message: "No screens found",
                        details: nil))
      return
    }
    
    // Set wallpaper for all screens
    do {
      for screen in screens {
        try NSWorkspace.shared.setDesktopImageURL(imageURL, for: screen, options: [:])
      }
      result(true)
    } catch {
      result(FlutterError(code: "SET_WALLPAPER_ERROR",
                        message: error.localizedDescription,
                        details: nil))
    }
  }
}
