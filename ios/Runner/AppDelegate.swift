import Flutter
import UIKit
import connectivity_plus
import shared_preferences_foundation

#if DEBUG
import google_mobile_ads
#endif

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    registerRequiredPlugins()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func registerRequiredPlugins() {
    registerPlugin(named: "ConnectivityPlusPlugin", using: ConnectivityPlusPlugin.register)
    registerPlugin(named: "SharedPreferencesPlugin", using: SharedPreferencesPlugin.register)

    #if DEBUG
    registerPlugin(named: "FLTGoogleMobileAdsPlugin", using: FLTGoogleMobileAdsPlugin.register)
    #endif
  }

  private func registerPlugin(
    named pluginName: String,
    using register: (FlutterPluginRegistrar) -> Void
  ) {
    guard let registrar = registrar(forPlugin: pluginName) else {
      assertionFailure("Missing registrar for \(pluginName)")
      return
    }
    register(registrar)
  }
}
