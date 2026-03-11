import Flutter
import UIKit
import UserMessagingPlatform

public class SwiftGdprDialogPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "gdpr_dialog", binaryMessenger: registrar.messenger())
    let instance = SwiftGdprDialogPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "gdpr.activate":
      guard let arg = call.arguments as? NSDictionary,
            let isTest = arg["isForTest"] as? Bool,
            let deviceId = arg["testDeviceId"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        return
      }
      checkConsent(result: result, isForTest: isTest, testDeviceId: deviceId)

    case "gdpr.getConsentStatus":
      getConsentStatus(result: result)

    case "gdpr.canRequestAds":
      result(ConsentInformation.shared.canRequestAds)

    case "gdpr.isPrivacyOptionsRequired":
      let status = ConsentInformation.shared.privacyOptionsRequirementStatus
      result(status == .required)

    case "gdpr.showPrivacyOptionsForm":
      showPrivacyOptionsForm(result: result)

    case "gdpr.reset":
      resetDecision(result: result)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - Consent Status

  private func getConsentStatus(result: @escaping FlutterResult) {
    let status = ConsentInformation.shared.consentStatus
    let statusString: String
    switch status {
    case .notRequired:
      statusString = "NOT_REQUIRED"
    case .required:
      statusString = "REQUIRED"
    case .obtained:
      statusString = "OBTAINED"
    case .unknown:
      statusString = "UNKNOWN"
    @unknown default:
      statusString = "UNKNOWN"
    }
    result(statusString)
  }

  // MARK: - Consent Flow (UMP SDK 3.x)

  private func checkConsent(result: @escaping FlutterResult, isForTest: Bool, testDeviceId: String) {
    let parameters = RequestParameters()
    parameters.isTaggedForUnderAgeOfConsent = false

    if isForTest {
      let debugSettings = DebugSettings()
      debugSettings.testDeviceIdentifiers = [testDeviceId]
      debugSettings.geography = .EEA
      parameters.debugSettings = debugSettings
    }

    // Step 1: Request consent info update
    ConsentInformation.shared.requestConsentInfoUpdate(with: parameters) { [self] error in
      if let error = error {
        print("Error on requestConsentInfoUpdate: \(error.localizedDescription)")
        result(false)
        return
      }

      // Step 2: Load and present consent form if required (UMP 3.x approach)
      guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = windowScene.keyWindow?.rootViewController else {
        // No view controller available — consent info updated but can't show form
        result(true)
        return
      }

      ConsentForm.loadAndPresentIfRequired(from: rootViewController) { formError in
        if let formError = formError {
          print("Error on loadAndPresentIfRequired: \(formError.localizedDescription)")
          result(false)
          return
        }
        // Form was shown and dismissed (or wasn't required)
        result(true)
      }
    }
  }

  // MARK: - Privacy Options Form

  private func showPrivacyOptionsForm(result: @escaping FlutterResult) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootViewController = windowScene.keyWindow?.rootViewController else {
      result(FlutterError(code: "NO_VIEW_CONTROLLER", message: "No root view controller available", details: nil))
      return
    }

    ConsentForm.presentPrivacyOptionsForm(from: rootViewController) { error in
      if let error = error {
        result(FlutterError(code: "FORM_ERROR", message: error.localizedDescription, details: nil))
        return
      }
      result(true)
    }
  }

  // MARK: - Reset

  private func resetDecision(result: @escaping FlutterResult) {
    ConsentInformation.shared.reset()
    result(true)
  }
}
