import 'package:flutter/material.dart';

import '../core/constants/colors.dart';
import '../core/constants/text_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      color: AppColors.primary,
      titleTextStyle: AppTextStyles.headline1,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: AppTextStyles.bodyText,
      bodySmall: AppTextStyles.caption,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.primary,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
