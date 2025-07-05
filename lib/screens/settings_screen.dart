import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../providers/theme_provider.dart';
import 'package:flutter/services.dart';
import 'rate_app_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _language = 'Indonesia';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _language = prefs.getString('language') ?? 'Indonesia';
    });
  }

  Future<void> _setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    setState(() {
      _language = language;
    });
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Bahasa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Indonesia'),
                value: 'Indonesia',
                groupValue: _language,
                onChanged: (value) {
                  if (value != null) {
                    _setLanguage(value);
                    Navigator.pop(context);
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('English'),
                value: 'English',
                groupValue: _language,
                onChanged: (value) {
                  if (value != null) {
                    _setLanguage(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(AppSpacing.md),
                children: [
                  _buildSection(
                    'Pengaturan Aplikasi',
                    [
                      _buildSettingItem(
                        'Notifikasi',
                        Icons.notifications_none,
                        true,
                        isDark,
                        (bool value) => _setNotificationsEnabled(value),
                        value: _notificationsEnabled,
                      ),
                      _buildSettingItem(
                        'Bahasa',
                        Icons.language,
                        false,
                        isDark,
                        _showLanguageDialog,
                        trailing: Text(
                          _language,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      _buildSettingItem(
                        'Mode Gelap',
                        Icons.dark_mode_outlined,
                        true,
                        isDark,
                        (bool value) => themeProvider.toggleTheme(),
                        value: themeProvider.isDarkMode,
                      ),
                    ],
                    isDark,
                  ),
                  SizedBox(height: AppSpacing.lg),
                  _buildSection(
                    'Bantuan & Dukungan',
                    [
                      _buildSettingItem(
                        'Pusat Bantuan',
                        Icons.help_outline,
                        false,
                        isDark,
                        _onHelpCenter,
                      ),
                      _buildSettingItem(
                        'Beri Rating',
                        Icons.star_border,
                        false,
                        isDark,
                        _onRateApp,
                      ),
                      _buildSettingItem(
                        'Tentang Aplikasi',
                        Icons.info_outline,
                        false,
                        isDark,
                        _onAboutApp,
                      ),
                    ],
                    isDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        boxShadow: AppShadows.small,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkPrimary : AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            'Pengaturan & Info',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.text,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBackground : Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppShadows.small,
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    String title,
    IconData icon,
    bool hasSwitch,
    bool isDark,
    dynamic onChanged, {
    Widget? trailing,
    bool? value,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? AppColors.darkCardBackground.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
          ),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: (isDark ? AppColors.darkPrimary : AppColors.primary)
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(
            icon,
            color: isDark ? AppColors.darkPrimary : AppColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.text,
            fontSize: 14,
          ),
        ),
        trailing: hasSwitch
            ? Switch(
                value: value ?? true,
                onChanged: onChanged,
                activeColor: isDark ? AppColors.darkPrimary : AppColors.primary,
              )
            : trailing ??
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  size: 16,
                ),
        onTap: hasSwitch ? null : onChanged,
      ),
    );
  }

  void _onHelpCenter() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pusat Bantuan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        padding: EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Help Items
                _buildHelpItem(
                  'Bagaimana cara memindai tanaman?',
                  'Buka menu Pindai, arahkan kamera ke tanaman yang ingin dipindai, dan ikuti petunjuk yang muncul di layar.',
                ),
                SizedBox(height: 16),
                Divider(height: 1, color: Colors.grey.shade200),
                SizedBox(height: 16),

                _buildHelpItem(
                  'Bagaimana cara melihat riwayat pemindaian?',
                  'Klik menu Riwayat di bagian bawah aplikasi untuk melihat semua hasil pemindaian sebelumnya.',
                ),
                SizedBox(height: 16),
                Divider(height: 1, color: Colors.grey.shade200),
                SizedBox(height: 16),

                _buildHelpItem(
                  'Bagaimana cara menghubungi dukungan?',
                  'Kirim email ke contact.tapinara@profil-faisal.my.id atau hubungi kami di nomor 0822-1234-5678.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          answer,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  void _onRateApp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RateAppScreen()),
    );
  }

  void _onAboutApp() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppColors.darkCardBackground : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppRadius.lg),
                    ),
                    child: Image.asset(
                      'assets/images/tim.jpg',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        Text(
                          'Tani Pintar Nusantara',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.text,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'Aplikasi yang membantu petani Indonesia dalam mendeteksi penyakit tanaman menggunakan teknologi kecerdasan buatan.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: AppSpacing.lg),
                        Text(
                          'Versi 1.0.0',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 8,
                top: 8,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
