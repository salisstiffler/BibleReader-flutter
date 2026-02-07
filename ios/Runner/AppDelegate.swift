import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var initialDeepLink: String? = nil
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Handle URL if app was launched from URL
    if let url = launchOptions?[.url] as? URL {
      initialDeepLink = url.absoluteString
    } else if let userActivity = launchOptions?[.userActivityDictionary] as? [AnyHashable: Any],
              let activity = userActivity[UIApplication.LaunchOptionsKey.userActivityType] as? NSUserActivity,
              let url = activity.webpageURL {
      initialDeepLink = url.absoluteString
    }
    
    // Set up MethodChannel for deeper link handling
    let controller = window?.rootViewController as? FlutterViewController
    guard let flutterController = controller else {
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    let channel = FlutterMethodChannel(name: "com.berlin.bible_reader/deeplink",
                                      binaryMessenger: flutterController.binaryMessenger)
    
    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "getInitialDeepLink" {
        result(self.initialDeepLink)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ app: UIApplication,
                          open url: URL,
                          options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    handleDeepLink(url)
    return true
  }
  
  private func handleDeepLink(_ url: URL) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      let controller = self.window?.rootViewController as? FlutterViewController
      guard let flutterController = controller else { return }
      
      let channel = FlutterMethodChannel(name: "com.berlin.bible_reader/deeplink",
                                        binaryMessenger: flutterController.binaryMessenger)
      channel.invokeMethod("onDeepLink", arguments: url.absoluteString)
    }
  }
}


