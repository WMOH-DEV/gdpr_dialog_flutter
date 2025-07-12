## 0.0.1

- TODO: First test release.

## 1.0.0

Write comments and release build

## 1.0.1

Bug fix

## 1.0.2

Bug fix

## 1.0.3

Add bool variable "isForTest" for testing library, set true to activate setDebugGeography
In release build set false or delete this argument!

## 1.0.4

Format library and add readme

## 1.0.5

Big fix test version, add 'testDeviceId' variable

## 1.0.6

Try catch block for returned result, cant find better solution

## 1.0.7

Check if activity is not finished before start form dialog

## 1.0.8

Add IOS functionality

## 1.0.9

Change description

## 1.1.0

Add function to set consent status as UNKNOWN

## 1.1.1

Critical fix ios consent result status. Add new function getConsentStatus

## 1.1.2

Add new function isRequestLocationInEea

## 1.1.3

Add new function set consent status as NON PERSONAL

## 1.1.4

Add new function set consent status as PERSONAL

## 1.1.5

Add LICENSE

## 2.0.0

Null safety

## 2.0.1

Add types for returning value and add default values if invokeMethod will return null value.

## 2.0.2

Add support test device on IOS platform. Thanks NoelRecords for pull request.

## 2.1.0

Upgraded package to Flutter 2.5, especially for Android v2 Embedding;
Changed android API from com.google.ads.consent to com.google.android.ump;
Removed setters for specified Consent Status;
Removed configuration parameters (publisherId and privacyUrl in showDialog function), due to uselessness;
Thanks Nikita Sadchenko for this update.

## 2.1.1

Fixed issue about non-responsable GDPR dialog

## 2.1.2 - FORK MODERNIZATION UPDATE 🚀

**Major modernization update for latest Flutter & Android compatibility**

### 🔧 Flutter & Dart Updates:

- Updated Flutter SDK constraint from `>=1.10.0` to `>=3.24.0`
- Updated Dart SDK constraint from `>=2.12.0 <3.0.0` to `>=3.0.0 <4.0.0`
- Now fully compatible with Flutter 3.32.5 and Dart 3.8.1

### 📱 Android Modernization:

- **Android Compile SDK**: Updated from API 30 to API 35 (Android 15)
- **Android Min SDK**: Updated from API 16 to API 21 (dropped Android 4.1-4.4 support)
- **Java Version**: Updated from Java 8 to Java 11 (LTS version)
- **Kotlin**: Updated to version 2.2.0 (latest stable)
- **Android Gradle Plugin**: Updated to 8.7.3
- **Gradle Wrapper**: Updated to 8.9
- **Google UMP Library**: Updated to 3.2.0 (latest stable)

### 🛠 Technical Improvements:

- Removed deprecated `jcenter()` repository, replaced with `mavenCentral()`
- Fixed NDK version mismatches (explicit NDK 27.0.12077973)
- Updated lint configurations from deprecated `lintOptions` to `lint` (AGP 8.7+ compatible)
- Modernized Java/Kotlin compatibility settings across all modules
- Added proper namespace support for Android Gradle Plugin 8.7+

### 🍎 iOS Updates:

- **iOS Deployment Target**: Updated from iOS 8.0 to iOS 12.0+ (modern iOS support)

### 📦 Dependencies:

- Updated `cupertino_icons` from ^1.0.2 to ^1.0.8
- All transitive dependencies updated to latest compatible versions

### ✅ Compatibility:

- ✅ Flutter 3.24.0+ (tested up to 3.32.5)
- ✅ Dart 3.0.0+ (tested with 3.8.1)
- ✅ Android 5.0+ (API 21+)
- ✅ iOS 13.0+
- ✅ Latest Android Studio & Xcode versions
- ✅ All deprecation warnings resolved

**This fork ensures your app stays compatible with the latest Flutter ecosystem!**
