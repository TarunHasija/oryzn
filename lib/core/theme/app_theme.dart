import 'package:flutter/material.dart';
import 'package:oryzn/core/constants/constants_export.dart';
import 'package:oryzn/core/theme/text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _buildTheme(AppColors.light());
  static ThemeData get darkTheme => _buildTheme(AppColors.dark());

  static ThemeData _buildTheme(AppColors colors) {
    return ThemeData(
      brightness: colors == AppColors.light()
          ? Brightness.light
          : Brightness.dark,
      scaffoldBackgroundColor: colors.surfacePrimary,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surfacePrimary,
        foregroundColor: colors.textIconPrimary,
        elevation: 0,
      ),
      textTheme: buildTextTheme(colors),
      iconTheme: IconThemeData(color: colors.textIconPrimary),
    );
  }
}
