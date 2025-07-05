import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String apiKey = 'AIzaSyBoiGbChCAF8x1GE4xMDwP0CDDDqzxuYYo';
  final GenerativeModel _textModel;
  final GenerativeModel _visionModel;

  GeminiService()
      : _textModel = GenerativeModel(
          model: 'gemini-pro',
          apiKey: apiKey,
        ),
        _visionModel = GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: apiKey,
          generationConfig: GenerationConfig(
            temperature: 0.7,
            maxOutputTokens: 1024,
          ),
        );

  Future<String> generateText(String prompt) async {
    try {
      print('Generating text with prompt: $prompt');
      final response = await _textModel.generateContent([
        Content.text(prompt),
      ]);
      final result = response.text ?? 'Tidak ada respon dari AI';
      print('Generated text result: $result');
      return result;
    } catch (e) {
      print('Error generating text: $e');
      return 'Error: $e';
    }
  }

  Future<String> analyzeImage(Uint8List imageBytes, String prompt) async {
    try {
      print('Analyzing image with prompt: $prompt');
      print('Image size: ${imageBytes.length} bytes');

      // Log format checking
      if (imageBytes.length >= 2) {
        print(
            'Image header: ${imageBytes[0].toRadixString(16).padLeft(2, '0')} ${imageBytes[1].toRadixString(16).padLeft(2, '0')}');
      }

      final response = await _visionModel.generateContent([
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ]);

      String result = response.text ?? 'Tidak ada respon dari AI';

      // Hapus duplikasi hasil analisis
      if (result.contains("**1. Identifikasi")) {
        int firstOccurrence = result.indexOf("**1. Identifikasi");
        int secondOccurrence =
            result.indexOf("**1. Identifikasi", firstOccurrence + 1);
        if (secondOccurrence != -1) {
          result = result.substring(0, secondOccurrence).trim();
        }
      }

      return result;
    } catch (e) {
      print('Error analyzing image: $e');
      if (e.toString().contains('overloaded')) {
        return 'Error: Layanan AI sedang sibuk. Mohon tunggu beberapa saat dan coba lagi.';
      } else if (e.toString().contains('UNAVAILABLE')) {
        return 'Error: Tidak dapat terhubung ke layanan AI. Pastikan perangkat terhubung ke internet dan coba lagi.';
      } else if (e.toString().contains('PERMISSION_DENIED')) {
        return 'Error: Akses ke layanan AI ditolak. Mohon periksa koneksi internet dan coba lagi.';
      } else if (e.toString().contains('RESOURCE_EXHAUSTED')) {
        return 'Error: Kuota penggunaan API telah habis. Silakan coba lagi nanti.';
      } else if (e.toString().contains('FAILED_PRECONDITION')) {
        return 'Error: Gagal memproses gambar. Pastikan gambar tidak terlalu besar dan coba lagi.';
      } else if (e.toString().contains('INVALID_ARGUMENT') ||
          e.toString().contains('Failed to process image')) {
        return 'Error: Format gambar tidak didukung. Harap gunakan gambar dalam format JPEG/JPG yang valid.';
      }
      return 'Error: Terjadi kesalahan saat menganalisis gambar. Pastikan perangkat terhubung ke internet dan coba lagi.';
    }
  }

  Future<bool> _validatePlantImage(Uint8List imageBytes) async {
    const validationPrompt = '''
    Analisis gambar ini dan jawab HANYA dengan "YES" atau "NO":
    Apakah gambar ini menunjukkan tanaman hidup (bukan gambar abstrak, bukan foto produk, bukan screenshot, bukan gambar kartun, dan bukan gambar selain tanaman hidup)?
    ''';

    try {
      final response = await _visionModel.generateContent([
        Content.multi([
          TextPart(validationPrompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ]);

      final result = response.text?.trim().toUpperCase() ?? 'NO';
      return result == 'YES';
    } catch (e) {
      print('Error validating plant image: $e');
      return false;
    }
  }

  Future<String> _analyzeImageContent(Uint8List imageBytes) async {
    const basePrompt = '''
    Analisis gambar tanaman ini secara detail dan berikan informasi dalam format berikut (dalam bahasa Indonesia):

    JENIS_TANAMAN: [identifikasi jenis/spesies tanaman]
    TAHAP_PERTUMBUHAN: [tahap pertumbuhan tanaman, misal: bibit, vegetatif, berbunga, dll]
    KONDISI_DAUN: [deskripsi kondisi daun seperti warna, bentuk, tekstur]
    KONDISI_BATANG: [deskripsi kondisi batang/tangkai]
    KONDISI_BUNGA/BUAH: [jika ada, deskripsi kondisi bunga atau buah]
    TANDA_NUTRISI: [indikasi kekurangan/kelebihan nutrisi jika terlihat]
    KONDISI_LINGKUNGAN: [deskripsi kondisi lingkungan sekitar tanaman]
    REKOMENDASI_UMUM: [saran umum berdasarkan kondisi yang terlihat]
    ''';

    try {
      final result = await analyzeImage(imageBytes, basePrompt);
      if (result.startsWith('Error:')) {
        throw Exception(result.substring(7));
      }
      return result;
    } catch (e) {
      throw Exception('Gagal menganalisis konten gambar: ${e.toString()}');
    }
  }

  Future<Map<String, String>> analyzeImageWithVision(
      Uint8List imageBytes) async {
    if (imageBytes.isEmpty) {
      throw Exception('Gambar tidak valid: File kosong');
    }

    if (imageBytes.length > 20 * 1024 * 1024) {
      throw Exception('Ukuran gambar terlalu besar. Maksimal 20MB');
    }

    try {
      // Validasi apakah gambar adalah tanaman
      final isPlantImage = await _validatePlantImage(imageBytes);
      if (!isPlantImage) {
        throw Exception(
            'Gambar yang diunggah bukan gambar tanaman. Mohon unggah foto tanaman yang valid.');
      }

      // Analisis konten gambar umum
      final visualAnalysis = await _analyzeImageContent(imageBytes);

      // Analisis penyakit tanaman
      final diseaseAnalysis = await detectPlantDisease(imageBytes);

      return {
        'visual_analysis': visualAnalysis,
        'disease_analysis': diseaseAnalysis,
      };
    } catch (e) {
      throw Exception('Gagal menganalisis gambar: ${e.toString()}');
    }
  }

  Future<String> detectPlantDisease(Uint8List imageBytes) async {
    if (imageBytes.isEmpty) {
      throw Exception('Gambar tidak valid: File kosong');
    }

    if (imageBytes.length > 20 * 1024 * 1024) {
      // 20MB limit
      throw Exception('Ukuran gambar terlalu besar. Maksimal 20MB');
    }

    // Tambahkan log untuk debugging
    print('Processing image with size: ${imageBytes.length} bytes');

    // Validasi format gambar
    try {
      // Cek magic numbers untuk format JPEG
      if (imageBytes.length < 2 ||
          imageBytes[0] != 0xFF ||
          imageBytes[1] != 0xD8) {
        throw Exception(
            'Format gambar tidak valid. Harap gunakan format JPEG/JPG');
      }
    } catch (e) {
      throw Exception('Gagal memvalidasi format gambar: ${e.toString()}');
    }

    const prompt = '''
    Analisis gambar tanaman ini dan berikan informasi dalam format yang TEPAT SAMA seperti berikut (dalam bahasa Indonesia), JANGAN menambahkan teks atau format lain:

    NAMA_PENYAKIT: [jika terdeteksi penyakit, tuliskan nama penyakitnya. Jika tidak ada penyakit, tulis "Tidak ada penyakit terdeteksi"]
    TINGKAT_KEPARAHAN: [angka persentase 0-100 tanpa simbol %, misal: 85]
    TINGKAT_KEPERCAYAAN: [tingkat kepercayaan analisis dalam angka 0-100 tanpa simbol %, misal: 95]
    DESKRIPSI: [deskripsi singkat kondisi tanaman, jika ada penyakit jelaskan gejalanya dan dampaknya]

    REKOMENDASI_PERAWATAN:
    - [judul tindakan]|[penjelasan detail tentang cara melakukan tindakan tersebut, alasan mengapa ini penting, dan hasil yang diharapkan]
    - [judul tindakan]|[penjelasan detail tentang cara melakukan tindakan tersebut, alasan mengapa ini penting, dan hasil yang diharapkan]
    - [judul tindakan]|[penjelasan detail tentang cara melakukan tindakan tersebut, alasan mengapa ini penting, dan hasil yang diharapkan]

    TIPS_PENCEGAHAN:
    - [judul tips]|[penjelasan detail tentang cara menerapkan tips ini, mengapa ini efektif, dan bagaimana melakukannya dengan benar]
    - [judul tips]|[penjelasan detail tentang cara menerapkan tips ini, mengapa ini efektif, dan bagaimana melakukannya dengan benar]
    - [judul tips]|[penjelasan detail tentang cara menerapkan tips ini, mengapa ini efektif, dan bagaimana melakukannya dengan benar]
    - [judul tips]|[penjelasan detail tentang cara menerapkan tips ini, mengapa ini efektif, dan bagaimana melakukannya dengan benar]
    ''';

    try {
      final result = await analyzeImage(imageBytes, prompt);
      if (result.startsWith('Error:')) {
        throw Exception(result.substring(7)); // Remove 'Error: ' prefix
      }
      return result;
    } catch (e) {
      if (e.toString().contains('overloaded')) {
        throw Exception(
            'Layanan AI sedang sibuk. Mohon tunggu beberapa saat dan coba lagi.');
      } else if (e.toString().contains('UNAVAILABLE')) {
        throw Exception(
            'Tidak dapat terhubung ke layanan AI. Pastikan perangkat terhubung ke internet.');
      } else if (e.toString().contains('PERMISSION_DENIED')) {
        throw Exception(
            'Akses ke layanan AI ditolak. Mohon periksa koneksi internet.');
      } else if (e.toString().contains('RESOURCE_EXHAUSTED')) {
        throw Exception(
            'Kuota penggunaan API telah habis. Silakan coba lagi nanti.');
      } else if (e.toString().contains('FAILED_PRECONDITION')) {
        throw Exception(
            'Gagal memproses gambar. Pastikan format gambar didukung.');
      }
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<String> getPlantingAdvice(String plantType) async {
    final prompt = '''
    Berikan saran lengkap dalam bahasa Indonesia tentang cara menanam dan merawat $plantType, termasuk:
    1. Kondisi tanah yang ideal
    2. Kebutuhan air dan cahaya
    3. Jarak tanam yang disarankan
    4. Waktu yang tepat untuk menanam
    5. Cara pemupukan yang benar
    6. Potensi hama dan penyakit yang perlu diwaspadai
    7. Tips khusus untuk hasil panen maksimal
    ''';

    return generateText(prompt);
  }

  Future<String> getFertilizerRecommendation(
      String plantType, String currentCondition) async {
    final prompt = '''
    Berikan rekomendasi pemupukan dalam bahasa Indonesia untuk tanaman $plantType dengan kondisi: $currentCondition
    Mencakup:
    1. Jenis pupuk yang sesuai
    2. Dosis yang dianjurkan
    3. Waktu dan frekuensi pemupukan
    4. Cara aplikasi yang benar
    5. Tanda-tanda kekurangan atau kelebihan pupuk
    ''';

    return generateText(prompt);
  }
}
