# Tani Pintar Nusantara / Smart Farming Nusantara

---

## Overview / Gambaran Umum

**Tani Pintar Nusantara** is a cutting-edge cross-platform mobile application developed with Flutter, designed to empower farmers and agricultural stakeholders by providing AI-driven plant disease detection and management tools. The app leverages advanced machine learning models to analyze plant images, delivering accurate diagnostics and actionable insights.

**Tani Pintar Nusantara** adalah aplikasi mobile lintas platform yang dikembangkan dengan Flutter, dirancang untuk memberdayakan petani dan pelaku pertanian dengan menyediakan deteksi penyakit tanaman berbasis AI dan alat manajemen. Aplikasi ini memanfaatkan model pembelajaran mesin canggih untuk menganalisis gambar tanaman, memberikan diagnosa akurat dan wawasan yang dapat ditindaklanjuti.

---

## Key Features / Fitur Utama

- **AI-Powered Plant Disease Detection / Deteksi Penyakit Tanaman Berbasis AI**  
  Analyze plant images using state-of-the-art AI models to identify diseases with confidence scores.  
  Menganalisis gambar tanaman menggunakan model AI terkini untuk mengidentifikasi penyakit dengan tingkat kepercayaan.

- **Multi-Platform Support / Dukungan Multi-Platform**  
  Native support for Android and iOS platforms ensuring wide accessibility.  
  Dukungan native untuk platform Android dan iOS agar dapat diakses secara luas.

- **Robust State Management / Manajemen State yang Kuat**  
  Utilizes Provider for scalable and maintainable state handling.  
  Menggunakan Provider untuk pengelolaan state yang skalabel dan mudah dipelihara.

- **Localization & Theming / Lokalisasi & Tema**  
  Supports English and Indonesian languages with dynamic theme switching (light/dark mode).  
  Mendukung bahasa Inggris dan Indonesia dengan pengaturan tema dinamis (mode terang/gelap).

- **Comprehensive History Management / Manajemen Riwayat Lengkap**  
  Searchable, filterable, and sortable analysis history with undo and batch delete capabilities.  
  Riwayat analisis yang dapat dicari, difilter, dan diurutkan dengan fitur undo dan hapus massal.

- **Intuitive User Interface / Antarmuka Pengguna Intuitif**  
  Smooth navigation with bottom navigation bar and responsive design.  
  Navigasi lancar dengan bottom navigation bar dan desain responsif.

---

## Architecture & Code Structure / Arsitektur & Struktur Kode

- **`android/` & `ios/`**: Platform-specific native code and configurations.  
  Kode dan konfigurasi native khusus platform.

- **`lib/`**: Core Flutter application codebase.  
  Kode sumber utama aplikasi Flutter.  
  - **`models/`**: Data models representing analysis results and app entities.  
    Model data yang merepresentasikan hasil analisis dan entitas aplikasi.  
  - **`providers/`**: State management classes using ChangeNotifier.  
    Kelas manajemen state menggunakan ChangeNotifier.  
  - **`screens/`**: UI screens including Home, Scan, History, Settings, and Analysis Detail.  
    Layar UI seperti Beranda, Pindai, Riwayat, Pengaturan, dan Detail Analisis.  
  - **`services/`**: Backend services such as local storage and AI integration.  
    Layanan backend seperti penyimpanan lokal dan integrasi AI.  
  - **`theme/`**: Theme definitions and styling constants.  
    Definisi tema dan konstanta styling.  
  - **`utils/`**: Utility functions and constants.  
    Fungsi utilitas dan konstanta.  
  - **`widgets/`**: Reusable UI components.  
    Komponen UI yang dapat digunakan ulang.  
  - **`l10n/`**: Localization resources and delegates.  
    Sumber daya dan delegasi lokalisasi.

- **`assets/`**: Static assets such as images.  
  Aset statis seperti gambar.

---

## Installation & Build Instructions / Instruksi Instalasi & Build

### Prerequisites / Prasyarat
- Flutter SDK (compatible version)  
- Android Studio or Xcode for platform-specific builds  
- Connected Android/iOS device or emulator  

### Setup / Pengaturan
1. Clone the repository / Clone repositori:  
   ```bash
   git clone https://github.com/Paichong29/tani_pintar_nusantara
   cd tani_pintar_nusantara
   ```
2. replace your api key gemini/ganti api key gemini
   ```bash
   static const String apiKey = 'replace_your_api_key_gemini_ganti_api_key_gemini';
   ```
3. Install dependencies / Instal dependensi:  
   ```bash
   flutter pub get
   ```
4. Clean previous builds (optional) / Bersihkan build sebelumnya (opsional):  
   ```bash
   flutter clean
   ```

### Build APK for Android / Build APK untuk Android
```bash
flutter build apk --release
```
- The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.  
- APK dapat ditemukan di `build/app/outputs/flutter-apk/app-release.apk`.  
- Transfer and install on your Android device for testing.  
- Transfer dan instal di perangkat Android untuk pengujian.

### Build for iOS / Build untuk iOS
- Open the iOS project in Xcode:  
  ```bash
  open ios/Runner.xcworkspace
  ```
- Configure signing & capabilities.  
- Build and run on a connected iOS device or simulator.  

---

## Usage Guide / Panduan Penggunaan

- Launch the app to access the Home screen with recent analysis summary.  
- Gunakan aplikasi untuk membuka layar Beranda dengan ringkasan analisis terbaru.  
- Navigate using the bottom navigation bar to Scan, History, and Settings.  
- Navigasi menggunakan bottom navigation bar ke Pindai, Riwayat, dan Pengaturan.  
- Capture or select plant images to initiate AI analysis.  
- Ambil atau pilih gambar tanaman untuk memulai analisis AI.  
- View detailed results and recommendations.  
- Lihat hasil dan rekomendasi secara detail.  
- Manage analysis history with search, filters, and batch operations.  
- Kelola riwayat analisis dengan pencarian, filter, dan operasi massal.  
- Customize app appearance and language in Settings.  
- Sesuaikan tampilan dan bahasa aplikasi di Pengaturan.

---

## Development Notes / Catatan Pengembangan

- Centralized state management with Provider for scalability.  
- Manajemen state terpusat menggunakan Provider untuk skalabilitas.  
- Local storage abstracted in `StorageService` for flexibility.  
- Penyimpanan lokal diabstraksi dalam `StorageService` untuk fleksibilitas.  
- Modular AI integration for easy upgrades.  
- Integrasi AI modular untuk kemudahan upgrade.  
- Localization follows Flutter best practices with ARB files.  
- Lokalisasi mengikuti praktik terbaik Flutter dengan file ARB.  
- Dynamic theming for consistent UI experience.  
- Tema dinamis untuk pengalaman UI yang konsisten.

---

## Contribution Guidelines / Panduan Kontribusi

- Fork the repository and create feature branches.  
- Fork repositori dan buat branch fitur.  
- Follow Dart and Flutter best practices and style guides.  
- Ikuti praktik terbaik dan gaya penulisan Dart dan Flutter.  
- Write unit and widget tests for new features or bug fixes.  
- Tulis unit dan widget test untuk fitur baru atau perbaikan bug.  
- Submit pull requests with clear descriptions and linked issues.  
- Ajukan pull request dengan deskripsi jelas dan tautan isu.

---

## Contact / Kontak

For inquiries, feature requests, or support, please contact:  
Untuk pertanyaan, permintaan fitur, atau dukungan, silakan hubungi:

- Name / Nama: Paichong29  
- Email: contact.tapinara@profil-faisal.my.id  
- GitHub: Paichong29  


