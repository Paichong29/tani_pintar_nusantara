# Dokumentasi Kode Sumber - Tani Pintar Nusantara

## Gambaran Umum
Dokumen ini memberikan panduan dan standar untuk mendokumentasikan kode sumber proyek Tani Pintar Nusantara guna memastikan pemeliharaan dan kolaborasi yang mudah.

## 1. Komentar Kode
- Gunakan komentar gaya DartDoc (`///`) untuk kelas, metode, dan properti publik.
- Berikan deskripsi yang jelas tentang fungsi, parameter, dan nilai kembali.
- Komentari logika dan algoritma yang kompleks untuk kejelasan.

## 2. Organisasi File
- Kelompokkan kelas dan fungsi terkait ke dalam file dan folder yang sesuai.
- Ikuti konvensi penamaan yang konsisten untuk file dan kelas.

## 3. Konvensi Penamaan
- Gunakan camelCase untuk variabel dan metode.
- Gunakan PascalCase untuk nama kelas.
- Gunakan nama yang deskriptif dan bermakna.

## 4. Alat Dokumentasi
- Gunakan DartDoc untuk menghasilkan dokumentasi API.
- Perbarui dokumentasi secara berkala sesuai perubahan kode.

## 5. Contoh
```dart
/// Merepresentasikan hasil analisis penyakit tanaman.
/// 
/// Berisi detail seperti nama penyakit, status, skor kepercayaan, dan rekomendasi.
class AnalysisResult {
  final String diseaseName;
  final String status;
  final double confidence;
  final String recommendations;

  /// Membuat instance AnalysisResult.
  AnalysisResult(this.diseaseName, this.status, this.confidence, this.recommendations);
}
```

## 6. Praktik Terbaik
- Hindari komentar yang berlebihan.
- Buat komentar singkat dan relevan.
- Tinjau dokumentasi saat review kode.

---

*Mematuhi standar dokumentasi ini akan meningkatkan kualitas kode dan memudahkan onboarding kontributor baru.*
