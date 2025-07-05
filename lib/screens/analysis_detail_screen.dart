import 'package:flutter/material.dart';
import 'dart:io';
import '../utils/constants.dart';

class AnalysisDetailScreen extends StatelessWidget {
  final String title;
  final String status;
  final String description;
  final String time;
  final String imagePath;
  final String selectedPlantType;

  const AnalysisDetailScreen({
    Key? key,
    required this.title,
    required this.status,
    required this.description,
    required this.time,
    required this.imagePath,
    required this.selectedPlantType,
  }) : super(key: key);

  @override
  Map<String, dynamic> _parseAnalysisResult(String result) {
    final Map<String, dynamic> parsedResult = {};

    try {
      final lines = result.split('\n');
      List<String> rekomendasi = [];
      List<String> tips = [];
      bool isRekomendasi = false;
      bool isTips = false;

      for (var line in lines) {
        line = line.trim();
        if (line.isEmpty) continue;

        if (line.startsWith('NAMA_PENYAKIT:')) {
          parsedResult['nama_penyakit'] = line.split(':')[1].trim();
        } else if (line.startsWith('TINGKAT_KEPARAHAN:')) {
          parsedResult['tingkat_keparahan'] = line.split(':')[1].trim();
        } else if (line.startsWith('TINGKAT_KEPERCAYAAN:')) {
          parsedResult['tingkat_kepercayaan'] = line.split(':')[1].trim();
        } else if (line.startsWith('DESKRIPSI:')) {
          parsedResult['deskripsi'] = line.split(':')[1].trim();
        } else if (line.startsWith('JENIS_TANAMAN:')) {
          parsedResult['jenis_tanaman'] = line.split(':')[1].trim();
        } else if (line.startsWith('TAHAP_PERTUMBUHAN:')) {
          parsedResult['tahap_pertumbuhan'] = line.split(':')[1].trim();
        } else if (line.startsWith('KONDISI_DAUN:')) {
          parsedResult['kondisi_daun'] = line.split(':')[1].trim();
        } else if (line.startsWith('KONDISI_BATANG:')) {
          parsedResult['kondisi_batang'] = line.split(':')[1].trim();
        } else if (line.startsWith('KONDISI_BUNGA/BUAH:')) {
          parsedResult['kondisi_bunga_buah'] = line.split(':')[1].trim();
        } else if (line.startsWith('TANDA_NUTRISI:')) {
          parsedResult['tanda_nutrisi'] = line.split(':')[1].trim();
        } else if (line.startsWith('KONDISI_LINGKUNGAN:')) {
          parsedResult['kondisi_lingkungan'] = line.split(':')[1].trim();
        } else if (line.startsWith('REKOMENDASI_UMUM:')) {
          parsedResult['rekomendasi_umum'] = line.split(':')[1].trim();
        } else if (line == 'REKOMENDASI_PERAWATAN:') {
          isRekomendasi = true;
          isTips = false;
        } else if (line == 'TIPS_PENCEGAHAN:') {
          isRekomendasi = false;
          isTips = true;
        } else if (line.startsWith('- ')) {
          if (isRekomendasi) {
            rekomendasi.add(line.substring(2));
          } else if (isTips) {
            tips.add(line.substring(2));
          }
        }
      }

      parsedResult['rekomendasi'] = rekomendasi;
      parsedResult['tips'] = tips;
    } catch (e) {
      print('Error parsing analysis result: $e');
    }

    return parsedResult;
  }

  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final analysisData = _parseAnalysisResult(description);
    final isHealthy = status.toLowerCase().contains('sehat');

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : AppColors.text,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Analisis',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Status Overlay
            Container(
              width: double.infinity,
              height: 200,
              child: Stack(
                children: [
                  if (imagePath.isNotEmpty)
                    Image.file(
                      File(imagePath),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: AppSpacing.md,
                    left: AppSpacing.md,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: isHealthy ? AppColors.success : AppColors.error,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plant Type Card
                  Container(
                    padding: EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color:
                          isDark ? AppColors.darkCardBackground : Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: AppShadows.small,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Icon(
                            Icons.eco,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jenis Tanaman',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: AppSpacing.xs),
                              Text(
                                selectedPlantType,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : AppColors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Analysis Result Card
                  Container(
                    padding: EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color:
                          isDark ? AppColors.darkCardBackground : Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: AppShadows.small,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(AppSpacing.xs),
                              decoration: BoxDecoration(
                                color: isHealthy
                                    ? (isDark
                                            ? AppColors.darkSuccess
                                            : AppColors.success)
                                        .withOpacity(0.1)
                                    : (isDark
                                            ? AppColors.darkError
                                            : AppColors.error)
                                        .withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                              ),
                              child: Icon(
                                isHealthy
                                    ? Icons.check_circle
                                    : Icons.warning_amber_rounded,
                                color: isHealthy
                                    ? (isDark
                                        ? AppColors.darkSuccess
                                        : AppColors.success)
                                    : (isDark
                                        ? AppColors.darkError
                                        : AppColors.error),
                                size: 24,
                              ),
                            ),
                            SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (analysisData['nama_penyakit'] != null)
                                    Text(
                                      analysisData['nama_penyakit'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : AppColors.text,
                                      ),
                                    ),
                                  SizedBox(height: AppSpacing.xs),
                                  if (analysisData['tingkat_kepercayaan'] !=
                                      null)
                                    Text(
                                      'Tingkat Kepercayaan: ${analysisData['tingkat_kepercayaan']}',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white70
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (analysisData['tingkat_keparahan'] != null) ...[
                          SizedBox(height: AppSpacing.md),
                          Text(
                            'Tingkat Keparahan',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            child: LinearProgressIndicator(
                              value: double.parse(
                                      analysisData['tingkat_keparahan']
                                          .replaceAll('%', '')) /
                                  100,
                              backgroundColor: isDark
                                  ? AppColors.darkCardBackground
                                  : Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getSeverityColor(double.parse(
                                    analysisData['tingkat_keparahan']
                                        .replaceAll('%', ''))),
                              ),
                              minHeight: 8,
                            ),
                          ),
                        ],
                        if (analysisData['deskripsi'] != null) ...[
                          SizedBox(height: AppSpacing.md),
                          Text(
                            'Deskripsi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.text,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            analysisData['deskripsi'],
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Plant Information Card
                  if (analysisData['jenis_tanaman'] != null)
                    Container(
                      padding: EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCardBackground
                            : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: AppShadows.small,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informasi Tanaman',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.text,
                            ),
                          ),
                          SizedBox(height: AppSpacing.md),
                          _buildInfoRow('Tahap Pertumbuhan',
                              analysisData['tahap_pertumbuhan'] ?? '-', isDark),
                          _buildInfoRow('Kondisi Daun',
                              analysisData['kondisi_daun'] ?? '-', isDark),
                          _buildInfoRow('Kondisi Batang',
                              analysisData['kondisi_batang'] ?? '-', isDark),
                          if (analysisData['kondisi_bunga_buah'] != null)
                            _buildInfoRow('Kondisi Bunga/Buah',
                                analysisData['kondisi_bunga_buah'], isDark),
                          _buildInfoRow('Tanda Nutrisi',
                              analysisData['tanda_nutrisi'] ?? '-', isDark),
                          _buildInfoRow(
                              'Kondisi Lingkungan',
                              analysisData['kondisi_lingkungan'] ?? '-',
                              isDark),
                        ],
                      ),
                    ),

                  SizedBox(height: AppSpacing.lg),

                  // Recommendations Section
                  if (analysisData['rekomendasi'] != null &&
                      analysisData['rekomendasi'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rekomendasi Perawatan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.text,
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        ...analysisData['rekomendasi']
                            .map((rekomendasi) =>
                                _buildRecommendationItem(rekomendasi, isDark))
                            .toList(),
                      ],
                    ),

                  SizedBox(height: AppSpacing.lg),

                  // Prevention Tips Section
                  if (analysisData['tips'] != null &&
                      analysisData['tips'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tips Pencegahan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.text,
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        ...analysisData['tips']
                            .map((tip) => _buildPreventionTip(tip, isDark))
                            .toList(),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white70 : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.text,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String text, bool isDark) {
    final parts = text.split('|');
    final title = parts[0].trim();
    final description = parts.length > 1 ? parts[1].trim() : '';

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.medical_services_outlined,
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
                size: 20,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : AppColors.text,
                  ),
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: TextStyle(
                color: isDark ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreventionTip(String text, bool isDark) {
    final parts = text.split('|');
    final title = parts[0].trim();
    final description = parts.length > 1 ? parts[1].trim() : '';

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates_outlined,
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
                size: 20,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : AppColors.text,
                  ),
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: TextStyle(
                color: isDark ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getSeverityColor(double severity) {
    if (severity < 30) {
      return Colors.green;
    } else if (severity < 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
