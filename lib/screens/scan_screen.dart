import 'dart:io';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../services/gemini_service.dart';
import '../services/storage_service.dart';
import '../models/analysis_result.dart';
import '../providers/analysis_provider.dart';
import 'analysis_detail_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _isCameraInitialized = false;
  XFile? _pickedImage;
  String _selectedPlant = 'padi'; // Default value
  final GeminiService _geminiService = GeminiService();
  late StorageService _storageService;
  bool _isAnalyzing = false;
  String? _analysisResult;
  final List<String> _plants = ['padi', 'jagung', 'singkong', 'cabai', 'tomat'];

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndConnection();
  }

  Future<void> _checkPermissionsAndConnection() async {
    if (!await _checkInternetConnection()) {
      return;
    }
    await _checkPermissions();
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.noInternetConnection),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return false;
    }
    return true;
  }

  Future<void> _checkPermissions() async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.cameraPermissionRequired),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }

    if (Platform.isAndroid) {
      if (await Permission.storage.status.isDenied) {
        await Permission.storage.request();
      }
      if (await Permission.photos.status.isDenied) {
        await Permission.photos.request();
      }
    }

    await _initializeCamera();
    await _initializeStorage();
  }

  Future<void> _initializeStorage() async {
    _storageService = await StorageService.init();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.cameraNotFound),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      _initializeControllerFuture = _cameraController.initialize();

      try {
        await _initializeControllerFuture;
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menginisialisasi kamera: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saat mengakses kamera: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    if (_isCameraInitialized) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  Map<String, dynamic> _parseAnalysisResult(String result) {
    final Map<String, dynamic> data = {};
    final lines = result.split('\n');
    for (var line in lines) {
      if (line.contains(':')) {
        final parts = line.split(':');
        if (parts.length == 2) {
          final key = parts[0].trim().toLowerCase();
          final value = parts[1].trim();
          if (key == 'tingkat_keparahan' || key == 'tingkat_kepercayaan') {
            data[key] = int.tryParse(value.replaceAll('%', '')) ?? 0;
          } else {
            data[key] = value;
          }
        }
      }
    }
    return data;
  }

  Future<void> _pickImageFromGallery() async {
    if (Platform.isAndroid) {
      var storageStatus = await Permission.storage.status;
      var photosStatus = await Permission.photos.status;

      if (!storageStatus.isGranted && !photosStatus.isGranted) {
        storageStatus = await Permission.storage.request();
        photosStatus = await Permission.photos.request();

        if (!storageStatus.isGranted && !photosStatus.isGranted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    AppLocalizations.of(context)!.storagePermissionRequired),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }
    }

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
      _navigateToAnalysis(image);
    }
  }

  Future<void> _takePhoto() async {
    if (!_isCameraInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.cameraNotReady),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      final XFile photo = await _cameraController.takePicture();
      if (!mounted) return;

      final file = File(photo.path);
      if (!await file.exists()) {
        throw Exception('File gambar tidak ditemukan');
      }

      final fileSize = await file.length();
      if (fileSize == 0) {
        throw Exception('File gambar kosong');
      }

      setState(() {
        _pickedImage = photo;
      });
      _navigateToAnalysis(photo);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengambil foto: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _navigateToAnalysis(XFile image) async {
    if (!await _checkInternetConnection()) {
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final isDarkTheme =
            Theme.of(dialogContext).brightness == Brightness.dark;
        return Center(
          child: Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDarkTheme ? AppColors.darkCardBackground : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppShadows.small,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDarkTheme ? AppColors.darkPrimary : AppColors.primary,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Menganalisis gambar...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      final bytes = await File(image.path).readAsBytes();
      final visionResult = await _geminiService.analyzeImageWithVision(bytes);

      if (context.mounted) {
        Navigator.pop(context);
      }

      final diseaseAnalysis = visionResult['disease_analysis'] ?? '';

      setState(() {
        _analysisResult = diseaseAnalysis;
        _isAnalyzing = false;
      });

      final analysisData = _parseAnalysisResult(diseaseAnalysis);
      final String namaPenyakit =
          analysisData['nama_penyakit'] ?? 'Tidak dapat mendeteksi penyakit';
      final String status =
          namaPenyakit.toLowerCase().contains('tidak ada penyakit')
              ? 'Tanaman Sehat'
              : 'Terdeteksi Penyakit';

      final analysis = AnalysisResult(
        title:
            'Analisis ${_selectedPlant[0].toUpperCase() + _selectedPlant.substring(1)}',
        status: status,
        description: diseaseAnalysis,
        time: DateTime.now().toString(),
        imagePath: image.path,
        analysisData: analysisData,
      );

      if (!mounted) return;

      // Update provider first to ensure UI updates immediately
      final analysisProvider =
          Provider.of<AnalysisProvider>(context, listen: false);
      await analysisProvider.addAnalysis(analysis);

      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysisDetailScreen(
            title: analysis.title,
            status: analysis.status,
            description: analysis.description,
            time: analysis.time,
            imagePath: analysis.imagePath,
            selectedPlantType:
                _selectedPlant[0].toUpperCase() + _selectedPlant.substring(1),
          ),
        ),
      );

      // Navigate to history screen after analysis
      if (!mounted) return;
      final tabController = DefaultTabController.maybeOf(context);
      if (tabController != null) {
        tabController.animateTo(2); // Index 2 is history screen
      }
    } catch (e) {
      print('Error during analysis: $e');

      if (context.mounted) {
        Navigator.pop(context);
      }

      setState(() {
        _isAnalyzing = false;
      });

      if (context.mounted) {
        String errorMessage = e.toString();
        if (errorMessage.contains('bukan gambar tanaman')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Mohon unggah gambar tanaman yang valid. Sistem mendeteksi bahwa gambar yang diunggah bukan gambar tanaman.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 4),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menganalisis gambar: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildScanFrame(context, isDark),
                    SizedBox(height: AppSpacing.xl),
                    _buildPlantSelector(isDark),
                    SizedBox(height: AppSpacing.xl),
                    _buildTipsCard(isDark),
                    SizedBox(height: AppSpacing.xl),
                    _buildActionButtons(isDark),
                    if (_pickedImage != null) ...[
                      SizedBox(height: AppSpacing.lg),
                      Text(
                        'Preview Gambar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.text,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      Image.file(
                        File(_pickedImage!.path),
                        width: MediaQuery.of(context).size.width * 0.8,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Previous widget building methods remain the same...
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
              Icons.camera_alt,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            AppLocalizations.of(context)!.scanTitle,
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

  Widget _buildScanFrame(BuildContext context, bool isDark) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? AppColors.darkPrimary : AppColors.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            color: Colors.black.withOpacity(0.05),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: _buildCorner(true, true, isDark),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: _buildCorner(true, false, isDark),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: _buildCorner(false, true, isDark),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: _buildCorner(false, false, isDark),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: _isCameraInitialized
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: CameraPreview(_cameraController),
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? AppColors.darkPrimary : AppColors.primary,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCorner(bool isTop, bool isLeft, bool isDark) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkPrimary : AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isTop && isLeft ? 0 : AppRadius.sm),
          topRight: Radius.circular(isTop && !isLeft ? 0 : AppRadius.sm),
          bottomLeft: Radius.circular(!isTop && isLeft ? 0 : AppRadius.sm),
          bottomRight: Radius.circular(!isTop && !isLeft ? 0 : AppRadius.sm),
        ),
      ),
    );
  }

  Widget _buildPlantSelector(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.small,
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedPlant,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.local_florist,
            color: isDark ? AppColors.darkPrimary : AppColors.primary,
          ),
          labelText: AppLocalizations.of(context)!.selectPlant,
          labelStyle: TextStyle(
            color: isDark ? Colors.white70 : AppColors.textSecondary,
          ),
        ),
        dropdownColor: isDark ? AppColors.darkCardBackground : Colors.white,
        items: _plants.map((String plant) {
          return DropdownMenuItem<String>(
            value: plant,
            child: Text(
              plant[0].toUpperCase() + plant.substring(1),
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.text,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedPlant = newValue;
            });
          }
        },
      ),
    );
  }

  Widget _buildTipsCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.tips_and_updates,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                AppLocalizations.of(context)!.scanTipsTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.text,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          _buildTipItem(AppLocalizations.of(context)!.tipGoodLighting, isDark),
          _buildTipItem(AppLocalizations.of(context)!.tipFocusArea, isDark),
          _buildTipItem(AppLocalizations.of(context)!.tipKeepStable, isDark),
          _buildTipItem(AppLocalizations.of(context)!.tipWholePlant, isDark),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.darkPrimary : AppColors.primary)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              Icons.check,
              color: isDark ? AppColors.darkPrimary : AppColors.primary,
              size: 16,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _pickImageFromGallery,
              icon: Icon(
                Icons.photo_library_outlined,
                color: isDark ? Colors.white : AppColors.text,
              ),
              label: Text(
                AppLocalizations.of(context)!.gallery,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.text,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? AppColors.darkCardBackground : Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                elevation: 0,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
              ),
              label: Text(
                AppLocalizations.of(context)!.takePhoto,
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? AppColors.darkPrimary : AppColors.primary,
                padding: EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
