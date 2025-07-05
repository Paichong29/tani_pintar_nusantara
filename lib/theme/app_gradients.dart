import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AppGradients {
  static LinearGradient primary({bool isDark = false}) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        isDark ? AppColors.darkPrimary : AppColors.primary,
        isDark ? AppColors.darkPrimaryLight : AppColors.primaryLight,
      ],
    );
  }

  static LinearGradient success({bool isDark = false}) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        isDark ? AppColors.darkSuccess : AppColors.success,
        isDark ? AppColors.darkSuccessLight : AppColors.successLight,
      ],
    );
  }

  static LinearGradient warning({bool isDark = false}) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        isDark ? AppColors.darkWarning : AppColors.warning,
        isDark ? AppColors.darkWarningLight : AppColors.warningLight,
      ],
    );
  }

  static LinearGradient error({bool isDark = false}) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        isDark ? AppColors.darkError : AppColors.error,
        isDark ? AppColors.darkErrorLight : AppColors.errorLight,
      ],
    );
  }
}
