import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/theme_provider.dart';
import '../providers/analysis_provider.dart';
import '../models/analysis_result.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'analysis_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _navigateToScanScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScanScreen()),
    );
  }

  Future<void> _navigateToHistoryScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final analysisProvider = Provider.of<AnalysisProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, isDark, themeProvider),
                SizedBox(height: AppSpacing.lg),
                _buildGreeting(context, isDark),
                SizedBox(height: AppSpacing.lg),
                _buildScanCard(context, isDark),
                SizedBox(height: AppSpacing.lg),
                _buildRecentAnalysis(context, isDark, analysisProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, bool isDark, ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.eco,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.appTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(),
              activeColor: isDark ? AppColors.darkPrimary : AppColors.primary,
            ),
            SizedBox(width: AppSpacing.sm),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: AppShadows.small,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
                onPressed: () {
                  _showSnackBar(context, 'Fitur notifikasi belum tersedia');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGreeting(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.greeting,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.text,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          AppLocalizations.of(context)!.greetingSubtitle,
          style: TextStyle(
            fontSize: 16,
            color:
                isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildScanCard(BuildContext context, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToScanScreen(context),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Ink(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkPrimary : AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppShadows.primary,
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.quickScan,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        AppLocalizations.of(context)!.quickScanDesc,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentAnalysis(
      BuildContext context, bool isDark, AnalysisProvider analysisProvider) {
    if (analysisProvider.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            isDark ? AppColors.darkPrimary : AppColors.primary,
          ),
        ),
      );
    }

    final recentAnalyses = analysisProvider.getRecentAnalyses(5);

    if (recentAnalyses.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noRecentAnalysis,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white : AppColors.textSecondary,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.recentAnalysis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.text,
              ),
            ),
            TextButton(
              onPressed: () => _navigateToHistoryScreen(context),
              child: Text(
                AppLocalizations.of(context)!.viewAll,
                style: TextStyle(
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        ...recentAnalyses.map((analysis) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: _buildAnalysisItemFromResult(analysis, isDark, context),
            )),
      ],
    );
  }

  Widget _buildAnalysisItemFromResult(
    AnalysisResult analysis,
    bool isDark,
    BuildContext context,
  ) {
    final bool isHealthy = analysis.status.toLowerCase().contains('sehat');
    final Color statusColor = isHealthy
        ? (isDark ? AppColors.darkSuccess : AppColors.success)
        : (isDark ? AppColors.darkError : AppColors.error);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final plantType = analysis.title.split(' ')[1];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnalysisDetailScreen(
                title: analysis.title,
                status: analysis.status,
                description: analysis.description,
                time: analysis.time,
                imagePath: analysis.imagePath,
                selectedPlantType: plantType,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Ink(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBackground : Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppShadows.small,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  isHealthy ? Icons.check_circle : Icons.warning,
                  color: statusColor,
                  size: 24,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      analysis.title,
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      analysis.status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (analysis.analysisData['tingkat_kepercayaan'] != null)
                      Text(
                        'Tingkat Kepercayaan: ${analysis.analysisData['tingkat_kepercayaan']}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                _formatTime(analysis.time),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String time) {
    final date = DateTime.parse(time);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 2) {
      return 'Kemarin';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}
