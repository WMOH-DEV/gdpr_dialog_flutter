## GDPR dialog

**🔧 This is a modernized fork with latest Flutter & Android compatibility!**

## 🚀 What's New in This Fork (v2.1.2)

This fork has been fully upgraded to support the latest Flutter and Android ecosystem:

### ✅ **Major Upgrades Applied:**

- **Flutter SDK**: Updated to support Flutter 3.24.0+ (tested with 3.32.5)
- **Dart SDK**: Updated to 3.0.0+ (supports latest Dart 3.8.1)
- **Android Compile SDK**: Updated to API 35 (Android 15)
- **Android Min SDK**: Updated to API 21 (dropped Android 4.1-4.4 for modern features)
- **Java Version**: Updated to Java 11 (LTS version)
- **Kotlin**: Updated to 2.2.0 (latest stable)
- **Android Gradle Plugin**: Updated to 8.7.3
- **Gradle**: Updated to 8.9
- **iOS Deployment Target**: Updated to iOS 13.0+
- **Google UMP Library**: Updated to 3.2.0 (latest)

### 🛠 **Technical Improvements:**

- Removed deprecated `jcenter()` repository
- Fixed NDK version mismatches
- Updated lint configurations for AGP 8.7+
- Modernized Java/Kotlin compatibility settings
- Fixed all deprecation warnings

### 📱 **Compatibility:**

- ✅ Flutter 3.24.0+ (tested up to 3.32.5)
- ✅ Android 5.0+ (API 21+)
- ✅ iOS 13.0+
- ✅ Latest Android Studio & Xcode versions

---

### 📦 **Installation (Fork Version)**

To use this modernized fork in your `pubspec.yaml`:

```yaml
dependencies:
  gdpr_dialog:
    git:
      url: https://github.com/WMOH-DEV/gdpr_dialog_flutter.git
      ref: master
```

---

## 📖 Original Documentation

"showDialog()" calling: gets native request to android/ios Consent Form dialog and sets result as boolean:

- true = requested Consent Form loaded (but may not be shown);
- false = error with Consent Form loading.

Bool variable "isForTest" for testing library, set true to activate setDebugGeography. (works only for Android)
In release build set false or delete this argument!

"testDeviceId" you can find in logs.

If user already chose one of Consent Form variants and call it a second time:

- in iOS form will be shown and the user can change their consent option;
- in Android form will not be shown. **_To reset the choice_** user need to reinstall the app.

### Usage

```
GdprDialog.instance.showDialog(isForTest: true, testDeviceId: 'xxxxxxxxxxxxxxx')
                      .then((onValue) {
                    print('result === $onValue');
                  });
```

In the release build, you only does not need a parameters.

#### Method getConsentStatus() that return consent status

### Usage

```
GdprDialog.instance.getConsentStatus();
```

It will return string of consent status:

- OBTAINED
- REQUIRED
- NOT_REQUIRED
- UNKNOWN

### Statuses explaining

API, which depends on Android v2 Embedding, can not show you the real status of personalized ad.

- OBTAINED status means, that user already chose one of the variants ('Consent' or 'Do not consent');
- REQUIRED status means, that form should be shown by user, because his location is at EEA or UK;
- NOT_REQUIRED status means, that form would not be shown by user, because his location is not at EEA or UK;
- UNKNOWN status means, that there is no information about user location.
