import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color primary = Color(0xFF27AE60);
  static const Color primaryLight = Color(0xFF2ECC71);
  static const Color success = Color(0xFF28A745);
  static const Color successLight = Color(0xFF34C759);
  static const Color warning = Color(0xFFFFC107);
  static const Color warningLight = Color(0xFFFFD54F);
  static const Color error = Color(0xFFDC3545);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color background = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF2ECC71);
  static const Color darkPrimaryLight = Color(0xFF27AE60);
  static const Color darkSuccess = Color(0xFF34C759);
  static const Color darkSuccessLight = Color(0xFF28A745);
  static const Color darkWarning = Color(0xFFFFD54F);
  static const Color darkWarningLight = Color(0xFFFFC107);
  static const Color darkError = Color(0xFFEF5350);
  static const Color darkErrorLight = Color(0xFFDC3545);
  static const Color darkSurface = Color(0xFF212529);
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFADB5BD);
  static const Color darkCardBackground = Color(0xFF343A40);
}

class AppRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

class AppShadows {
  static List<BoxShadow> small = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> primary = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> success = [
    BoxShadow(
      color: AppColors.success.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> warning = [
    BoxShadow(
      color: AppColors.warning.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> error = [
    BoxShadow(
      color: AppColors.error.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];
}
