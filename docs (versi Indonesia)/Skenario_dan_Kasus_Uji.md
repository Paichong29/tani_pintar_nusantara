# Skenario dan Kasus Uji - Tani Pintar Nusantara

## 1. Skenario Uji: Pengambilan Gambar Tanaman
- **Kasus Uji 1.1:** Mengambil gambar menggunakan kamera
  - Langkah: Buka layar Pindai → Ketuk tombol ambil gambar → Verifikasi gambar berhasil diambil
  - Hasil yang Diharapkan: Gambar berhasil diambil dan ditampilkan untuk analisis
- **Kasus Uji 1.2:** Mengunggah gambar dari galeri
  - Langkah: Buka layar Pindai → Pilih unggah → Pilih gambar → Verifikasi gambar dimuat
  - Hasil yang Diharapkan: Gambar berhasil dimuat dan siap dianalisis

## 2. Skenario Uji: Analisis AI
- **Kasus Uji 2.1:** Mengirim gambar untuk analisis
  - Langkah: Ambil atau unggah gambar → Kirim untuk analisis
  - Hasil yang Diharapkan: Hasil analisis diterima dalam waktu 10 detik
- **Kasus Uji 2.2:** Menangani gambar tidak valid
  - Langkah: Kirim gambar bukan tanaman
  - Hasil yang Diharapkan: Muncul pesan error dan permintaan untuk mencoba ulang

## 3. Skenario Uji: Manajemen Riwayat
- **Kasus Uji 3.1:** Melihat riwayat analisis
  - Langkah: Navigasi ke layar Riwayat
  - Hasil yang Diharapkan: Daftar hasil analisis ditampilkan
- **Kasus Uji 3.2:** Mencari riwayat
  - Langkah: Masukkan kata kunci pencarian
  - Hasil yang Diharapkan: Daftar hasil terfilter sesuai kata kunci
- **Kasus Uji 3.3:** Menghapus item riwayat
  - Langkah: Geser untuk hapus atau pilih opsi hapus
  - Hasil yang Diharapkan: Item terhapus dengan opsi undo

## 4. Skenario Uji: Pengaturan
- **Kasus Uji 4.1:** Mengubah bahasa
  - Langkah: Buka Pengaturan → Pilih bahasa → Verifikasi UI berubah
  - Hasil yang Diharapkan: Bahasa aplikasi berubah sesuai pilihan
- **Kasus Uji 4.2:** Mengubah tema
  - Langkah: Buka Pengaturan → Toggle tema
  - Hasil yang Diharapkan: Tema aplikasi berganti antara terang dan gelap

## 5. Skenario Uji: Notifikasi
- **Kasus Uji 5.1:** Menerima notifikasi selesai analisis
  - Langkah: Kirim gambar untuk analisis → Tunggu notifikasi
  - Hasil yang Diharapkan: Notifikasi diterima saat analisis selesai

---

*Dokumen ini memastikan fungsi utama aplikasi diuji secara menyeluruh untuk menjamin kualitas.*
