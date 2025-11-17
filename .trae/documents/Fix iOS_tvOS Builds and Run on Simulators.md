## Findings
- iOS app project at `AquaLog-iOS/AquaLog.xcodeproj`; tvOS app project at `AquaLog-tvOS/AquaLogTV.xcodeproj`.
- iOS build settings: `IPHONEOS_DEPLOYMENT_TARGET=14.5` (`AquaLog-iOS/AquaLog.xcodeproj/project.pbxproj:288,343,360,379`), `SWIFT_VERSION=5.0` (`project.pbxproj:367,386`), `INFOPLIST_FILE=AquaLog/Info.plist` (`project.pbxproj:359,378`).
- tvOS build settings: `TVOS_DEPLOYMENT_TARGET=14.0` (`AquaLog-tvOS/AquaLogTV.xcodeproj/project.pbxproj:251,311,331,350`), `SWIFT_VERSION=5.0` (`project.pbxproj:329,348`), `INFOPLIST_FILE=AquaLogTV/Info.plist` (`project.pbxproj:240,300,322,341`).
- tvOS `Info.plist` file is missing on disk (`AquaLog-tvOS/AquaLogTV/` shows no `Info.plist`).
- Schemes are not shared in source control; iOS only has a user scheme (`AquaLog-iOS/AquaLog.xcodeproj/xcuserdata/.../xcschemes/xcschememanagement.plist:7–11`) and there is no shared scheme for either app.

## Root Causes
- tvOS build failure: `INFOPLIST_FILE` points to a non-existent file → Xcode build fails with missing `Info.plist`.
- CLI/automation build failure: missing shared schemes → `xcodebuild -scheme` fails unless a shared scheme exists.

## Plan
1. Create tvOS `Info.plist` at `AquaLog-tvOS/AquaLogTV/Info.plist` with a minimal valid set:
   - `CFBundleIdentifier`, `CFBundleName`, `CFBundleVersion`, `CFBundleShortVersionString`, `LSRequiresIPhoneOS`, `UIMainStoryboardFile`/`UIApplicationSceneManifest` for SwiftUI, and tvOS-appropriate orientation/capability keys.
2. Add shared schemes:
   - iOS: add `AquaLog-iOS/AquaLog.xcodeproj/xcshareddata/xcschemes/AquaLog.xcscheme`.
   - tvOS: add `AquaLog-tvOS/AquaLogTV.xcodeproj/xcshareddata/xcschemes/AquaLogTV.xcscheme`.
3. Optional signing adjustments (if building for device): set `DEVELOPMENT_TEAM` in both projects or build with simulator destinations where signing is not required.
4. Build verification on simulators:
   - iOS: `xcodebuild -project AquaLog-iOS/AquaLog.xcodeproj -scheme AquaLog -destination 'platform=iOS Simulator,name=iPhone 15' build`.
   - tvOS: `xcodebuild -project AquaLog-tvOS/AquaLogTV.xcodeproj -scheme AquaLogTV -destination 'platform=tvOS Simulator,name=Apple TV' build`.
5. Run on simulators:
   - Use the built `.app` from `DerivedData` and launch via `xcrun simctl` for iOS and tvOS.

## What I Will Deliver
- A valid tvOS `Info.plist` with standard keys.
- Shared schemes committed for both apps.
- Successful simulator builds for iOS and tvOS, with launch commands provided and executed locally.

## Notes
- iOS `Info.plist` already contains HealthKit usage strings (`AquaLog-iOS/AquaLog/Info.plist:51–54`).
- iOS `UIRequiredDeviceCapabilities` lists `armv7`; we can modernize to `arm64` if needed, but it does not block simulator builds.