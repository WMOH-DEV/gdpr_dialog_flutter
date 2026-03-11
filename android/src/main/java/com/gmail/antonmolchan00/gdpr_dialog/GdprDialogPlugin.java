package com.gmail.antonmolchan00.gdpr_dialog;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import android.app.Activity;
import android.util.Log;

import com.google.android.ump.ConsentForm;
import com.google.android.ump.FormError;
import com.google.android.ump.UserMessagingPlatform;
import com.google.android.ump.ConsentInformation;
import com.google.android.ump.ConsentInformation.ConsentStatus;
import com.google.android.ump.ConsentDebugSettings;
import com.google.android.ump.ConsentRequestParameters;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

public class GdprDialogPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler {
  private Activity activity;
  private MethodChannel channel;
  private ConsentInformation consentInformation;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "gdpr_dialog");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
    this.activity = activityPluginBinding.getActivity();
    this.consentInformation = UserMessagingPlatform.getConsentInformation(activity);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    this.activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {
    this.activity = activityPluginBinding.getActivity();
    this.consentInformation = UserMessagingPlatform.getConsentInformation(activity);
  }

  @Override
  public void onDetachedFromActivity() {
    this.activity = null;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    try {
      switch (call.method) {
        case "gdpr.activate": {
          boolean isForTest = false;
          String testDeviceId = call.argument("testDeviceId");
          try {
            isForTest = call.argument("isForTest");
          } catch (Exception ignored) {
          }
          initializeForm(isForTest, testDeviceId, result);
          break;
        }
        case "gdpr.getConsentStatus":
          getConsentStatus(result);
          break;
        case "gdpr.canRequestAds":
          result.success(consentInformation != null && consentInformation.canRequestAds());
          break;
        case "gdpr.isPrivacyOptionsRequired":
          if (consentInformation != null) {
            result.success(consentInformation.getPrivacyOptionsRequirementStatus()
                == ConsentInformation.PrivacyOptionsRequirementStatus.REQUIRED);
          } else {
            result.success(false);
          }
          break;
        case "gdpr.showPrivacyOptionsForm":
          showPrivacyOptionsForm(result);
          break;
        case "gdpr.reset":
          resetDecision(result);
          break;
        default:
          result.notImplemented();
          break;
      }
    } catch (Exception e) {
      result.error("GDPR_ERROR", e.getMessage(), null);
    }
  }

  private void getConsentStatus(Result result) {
    String resultStatus = "ERROR";
    if (consentInformation != null) {
      int consentStatus = consentInformation.getConsentStatus();
      switch (consentStatus) {
        case ConsentStatus.UNKNOWN:
          resultStatus = "UNKNOWN";
          break;
        case ConsentStatus.OBTAINED:
          resultStatus = "OBTAINED";
          break;
        case ConsentStatus.REQUIRED:
          resultStatus = "REQUIRED";
          break;
        case ConsentStatus.NOT_REQUIRED:
          resultStatus = "NOT_REQUIRED";
          break;
      }
    }
    result.success(resultStatus);
  }

  public void initializeForm(boolean isForTest, String testDeviceId, Result result) {
    ConsentRequestParameters requestParams;

    if (isForTest) {
      ConsentDebugSettings debugSettings = new ConsentDebugSettings.Builder(activity)
          .setDebugGeography(ConsentDebugSettings.DebugGeography.DEBUG_GEOGRAPHY_EEA)
          .addTestDeviceHashedId(testDeviceId)
          .build();
      requestParams = new ConsentRequestParameters.Builder()
          .setConsentDebugSettings(debugSettings)
          .setTagForUnderAgeOfConsent(false)
          .build();
    } else {
      requestParams = new ConsentRequestParameters.Builder()
          .setTagForUnderAgeOfConsent(false)
          .build();
    }

    consentInformation.requestConsentInfoUpdate(activity, requestParams,
        new ConsentInformation.OnConsentInfoUpdateSuccessListener() {
          @Override
          public void onConsentInfoUpdateSuccess() {
            // UMP 3.x: Use loadAndShowConsentFormIfRequired instead of
            // manual isConsentFormAvailable() + loadConsentForm() + show()
            UserMessagingPlatform.loadAndShowConsentFormIfRequired(activity,
                new UserMessagingPlatform.OnConsentFormDismissedListener() {
                  @Override
                  public void onConsentFormDismissed(@Nullable FormError formError) {
                    if (formError != null) {
                      Log.w("GdprDialog", "Consent form error: " + formError.getMessage());
                    }
                    // Form was shown and dismissed, or wasn't required
                    result.success(true);
                  }
                });
          }
        },
        new ConsentInformation.OnConsentInfoUpdateFailureListener() {
          @Override
          public void onConsentInfoUpdateFailure(@NonNull FormError formError) {
            result.error(String.valueOf(formError.getErrorCode()), formError.getMessage(), null);
          }
        });
  }

  private void showPrivacyOptionsForm(Result result) {
    if (activity == null) {
      result.error("NO_ACTIVITY", "No activity available", null);
      return;
    }

    UserMessagingPlatform.showPrivacyOptionsForm(activity,
        new UserMessagingPlatform.OnConsentFormDismissedListener() {
          @Override
          public void onConsentFormDismissed(@Nullable FormError formError) {
            if (formError != null) {
              result.error("FORM_ERROR", formError.getMessage(), null);
              return;
            }
            result.success(true);
          }
        });
  }

  public void resetDecision(Result result) {
    try {
      if (consentInformation != null) {
        consentInformation.reset();
      }
      result.success(true);
    } catch (Exception e) {
      result.error("RESET_ERROR", e.getMessage(), null);
    }
  }
}
