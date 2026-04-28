import Flutter
import UIKit
import Photos

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let CHANNEL = "com.wallpaperapp/wallpaper"
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let wallpaperChannel = FlutterMethodChannel(name: CHANNEL,
                                                binaryMessenger: controller.binaryMessenger)
    
    wallpaperChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard let self = self else { return }
      
      switch call.method {
      case "saveToPhotos":
        guard let args = call.arguments as? [String: Any],
              let imagePath = args["imagePath"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENT",
                            message: "Image path is required",
                            details: nil))
          return
        }
        
        self.saveToPhotos(imagePath: imagePath, result: result)
        
      default:
        result(FlutterMethodNotImplemented)
      }
    })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
  
  private func saveToPhotos(imagePath: String, result: @escaping FlutterResult) {
    // Check if file exists
    guard FileManager.default.fileExists(atPath: imagePath) else {
      result(FlutterError(code: "FILE_NOT_FOUND",
                        message: "Image file not found",
                        details: nil))
      return
    }
    
    // Load image
    guard let image = UIImage(contentsOfFile: imagePath) else {
      result(FlutterError(code: "INVALID_IMAGE",
                        message: "Could not load image",
                        details: nil))
      return
    }
    
    // Check photo library permission
    let status = PHPhotoLibrary.authorizationStatus()
    
    if status == .notDetermined {
      // Request permission
      PHPhotoLibrary.requestAuthorization { newStatus in
        if newStatus == .authorized || newStatus == .limited {
          self.performSaveToPhotos(image: image, result: result)
        } else {
          result(FlutterError(code: "PERMISSION_DENIED",
                            message: "Photo library permission denied",
                            details: nil))
        }
      }
    } else if status == .authorized || status == .limited {
      performSaveToPhotos(image: image, result: result)
    } else {
      result(FlutterError(code: "PERMISSION_DENIED",
                        message: "Photo library permission denied. Please enable in Settings.",
                        details: nil))
    }
  }
  
  private func performSaveToPhotos(image: UIImage, result: @escaping FlutterResult) {
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAsset(from: image)
    }) { success, error in
      DispatchQueue.main.async {
        if success {
          result(true)
        } else {
          result(FlutterError(code: "SAVE_FAILED",
                            message: error?.localizedDescription ?? "Failed to save image",
                            details: nil))
        }
      }
    }
  }
}
