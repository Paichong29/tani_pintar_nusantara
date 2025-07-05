# Petunjuk Build dan Deployment - Tani Pintar Nusantara

## 1. Prasyarat
- Instal Flutter SDK (versi >=3.0.0 <4.0.0)
- Instal Android Studio dan/atau Xcode untuk build platform spesifik
- Siapkan perangkat atau emulator untuk pengujian

## 2. Setup Proyek
```bash
git clone <repository-url>
cd tani_pintar_nusantara
flutter pub get
flutter clean
```

## 3. Build APK Android
```bash
flutter build apk --release
```
- APK hasil build berada di `build/app/outputs/flutter-apk/app-release.apk`
- Transfer APK ke perangkat Android untuk instalasi

## 4. Build Aplikasi iOS
- Buka proyek iOS di Xcode:
```bash
open ios/Runner.xcworkspace
```
- Konfigurasi signing & capabilities
- Build dan jalankan di perangkat iOS atau simulator

## 5. Deployment
- Publikasikan APK ke Google Play Store sesuai panduan
- Publikasikan aplikasi iOS ke Apple App Store melalui App Store Connect

## 6. Continuous Integration (Opsional)
- Setup pipeline CI/CD menggunakan GitHub Actions atau alat lain
- Otomatiskan proses build, test, dan deployment

## 7. Troubleshooting
- Masalah umum dan solusinya
- Cara melaporkan masalah build

---

*Petunjuk ini memastikan proses build dan deployment yang konsisten dan andal.*
