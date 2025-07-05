# Build & Deployment Instructions - Tani Pintar Nusantara

## 1. Prerequisites
- Install Flutter SDK (version >=3.0.0 <4.0.0)
- Install Android Studio and/or Xcode for platform-specific builds
- Set up device or emulator for testing

## 2. Setup Project
```bash
git clone <repository-url>
cd tani_pintar_nusantara
flutter pub get
flutter clean
```

## 3. Build Android APK
```bash
flutter build apk --release
```
- Output APK located at `build/app/outputs/flutter-apk/app-release.apk`
- Transfer APK to Android device for installation

## 4. Build iOS App
- Open iOS project in Xcode:
```bash
open ios/Runner.xcworkspace
```
- Configure signing & capabilities
- Build and run on connected iOS device or simulator

## 5. Deployment
- Publish APK to Google Play Store following their guidelines
- Publish iOS app to Apple App Store via App Store Connect

## 6. Continuous Integration (Optional)
- Set up CI/CD pipelines using GitHub Actions or other tools
- Automate build, test, and deployment processes

## 7. Troubleshooting
- Common issues and solutions
- How to report build problems

---

*Following these instructions ensures consistent and reliable builds and deployments.*
