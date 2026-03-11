import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Plugin for managing GDPR consent using Google's UMP SDK 3.x.
///
/// Handles consent information updates, form presentation, and provides
/// methods to check if ads can be requested based on user consent.
class GdprDialog {
  static const MethodChannel _channel = MethodChannel('gdpr_dialog');

  // Singleton
  GdprDialog._();
  static final GdprDialog instance = GdprDialog._();

  /// Requests a consent information update and shows the consent form if
  /// required (UMP SDK 3.x `loadAndPresentIfRequired` flow).
  ///
  /// If [isForTest] is `true`, you must provide a [testDeviceId] (found in
  /// logcat / Xcode console) to simulate EEA geography.
  ///
  /// Returns `true` when the consent flow completes successfully (form shown
  /// and dismissed, or form not required). Returns `false` on error.
  Future<bool> showDialog({
    bool isForTest = false,
    String testDeviceId = '',
  }) async {
    try {
      final bool result =
          await _channel.invokeMethod('gdpr.activate', <String, dynamic>{
            'isForTest': isForTest,
            'testDeviceId': testDeviceId,
          }) ??
          false;
      debugPrint('GdprDialog: showDialog result = $result');
      return result;
    } on Exception catch (e) {
      debugPrint('GdprDialog: showDialog error: $e');
      return false;
    }
  }

  /// Returns the current [ConsentStatus].
  ///
  /// - [ConsentStatus.obtained] — user made a consent choice
  /// - [ConsentStatus.required] — form must be shown (EEA/UK user)
  /// - [ConsentStatus.notRequired] — outside EEA/UK, no form needed
  /// - [ConsentStatus.unknown] — status not yet determined
  Future<ConsentStatus> getConsentStatus() async {
    try {
      final String result =
          await _channel.invokeMethod('gdpr.getConsentStatus', []) ?? '';
      debugPrint('GdprDialog: consent status = $result');

      switch (result) {
        case 'REQUIRED':
          return ConsentStatus.required;
        case 'NOT_REQUIRED':
          return ConsentStatus.notRequired;
        case 'OBTAINED':
          return ConsentStatus.obtained;
        case 'UNKNOWN':
        default:
          return ConsentStatus.unknown;
      }
    } on Exception catch (e) {
      debugPrint('GdprDialog: getConsentStatus error: $e');
      return ConsentStatus.unknown;
    }
  }

  /// Returns `true` if the app can request ads based on the current consent
  /// state. This maps directly to UMP SDK's `canRequestAds` property.
  ///
  /// Use this instead of manually checking [ConsentStatus] to determine
  /// whether to initialize ad SDKs — it's the Google-recommended approach.
  Future<bool> canRequestAds() async {
    try {
      final bool result =
          await _channel.invokeMethod('gdpr.canRequestAds') ?? false;
      debugPrint('GdprDialog: canRequestAds = $result');
      return result;
    } on Exception catch (e) {
      debugPrint('GdprDialog: canRequestAds error: $e');
      return false;
    }
  }

  /// Returns `true` if a privacy options entry point should be shown to the
  /// user (e.g. a "Privacy Settings" button in your app's settings page).
  ///
  /// When this returns `true`, call [showPrivacyOptionsForm] when the user
  /// taps the privacy settings button.
  Future<bool> isPrivacyOptionsRequired() async {
    try {
      final bool result =
          await _channel.invokeMethod('gdpr.isPrivacyOptionsRequired') ?? false;
      debugPrint('GdprDialog: isPrivacyOptionsRequired = $result');
      return result;
    } on Exception catch (e) {
      debugPrint('GdprDialog: isPrivacyOptionsRequired error: $e');
      return false;
    }
  }

  /// Presents the privacy options form so the user can update their consent
  /// choices. Only call this when [isPrivacyOptionsRequired] returns `true`.
  ///
  /// Returns `true` on success, throws on error.
  Future<bool> showPrivacyOptionsForm() async {
    try {
      final bool result =
          await _channel.invokeMethod('gdpr.showPrivacyOptionsForm') ?? false;
      debugPrint('GdprDialog: showPrivacyOptionsForm result = $result');
      return result;
    } on PlatformException catch (e) {
      debugPrint('GdprDialog: showPrivacyOptionsForm error: $e');
      rethrow;
    }
  }

  /// Resets the consent state. Useful for testing to simulate a user's first
  /// install experience.
  Future<void> resetDecision() async {
    try {
      await _channel.invokeMethod('gdpr.reset');
      debugPrint('GdprDialog: consent decision reset');
    } on Exception catch (e) {
      debugPrint('GdprDialog: resetDecision error: $e');
    }
  }
}

/// Consent status values from Google's UMP SDK.
enum ConsentStatus {
  /// Form not required — user is outside EEA/UK.
  notRequired,

  /// Consent form must be shown — user is in EEA/UK.
  required,

  /// User has made a consent choice (consent or decline).
  obtained,

  /// Status not yet determined (before `requestConsentInfoUpdate`).
  unknown,
}
