import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/core/theme/theme_provider.dart';

/// Reactive color provider that switches based on theme
final appColorsProvider = Provider<AppColors>((ref) {
  final themeMode = ref.watch(themeProvider);
  return themeMode == ThemeMode.dark ? AppColors.dark() : AppColors.light();
});

class AppColors {
  final Color surfacePrimary;
  final Color textIconPrimary;
  final Color textIconSecondary;
  final Color surfaceSecondary;
  final Color strokeNeutral;
  final Color surfacePrimaryInvert;
  final Color textIconPrimaryInvert;
  final Color strokeNeutralVariant;
  final Color surfaceSecondaryVariant;
  final Color textIconSecondaryVariant;
  final Color surfacePrimaryVariant;
  final Color surfaceTertiary;
  final LinearGradient splashSvgGradient;
  final Color activeDay;

  const AppColors._({
    required this.surfacePrimary,
    required this.textIconPrimary,
    required this.textIconSecondary,
    required this.surfaceSecondary,
    required this.strokeNeutral,
    required this.surfacePrimaryInvert,
    required this.textIconPrimaryInvert,
    required this.strokeNeutralVariant,
    required this.surfaceSecondaryVariant,
    required this.textIconSecondaryVariant,
    required this.surfacePrimaryVariant,
    required this.surfaceTertiary,
    required this.splashSvgGradient,
    required this.activeDay,
  });

  factory AppColors.light() => const AppColors._(
    surfacePrimary: Color(0xFFFFFFFF),
    textIconPrimary: Color(0xFF1C1C1C),
    textIconSecondary: Color(0xFFABABAB),
    surfaceSecondary: Color(0xFFF0F0F0),
    strokeNeutral: Color(0xFFCFCFCF),
    surfacePrimaryInvert: Color(0xFF1C1C1C),
    textIconPrimaryInvert: Color(0xFFFFFFFF),
    strokeNeutralVariant: Color(0xFFC2C2C2),
    surfaceSecondaryVariant: Color(0xFFDFDFDF),
    textIconSecondaryVariant: Color(0xFFAAAAAA),
    surfacePrimaryVariant: Color(0xFF333333),
    surfaceTertiary: Color(0xFFD5D5D5),
    splashSvgGradient: LinearGradient(
      colors: [Color(0xFFFFFFFF), Color(0xFFB8B8B8)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    activeDay: Color(0xFFFF4400),
  );

  factory AppColors.dark() => const AppColors._(
    surfacePrimary: Color(0xFF1C1C1C),
    textIconPrimary: Color(0xFFFFFFFF),
    textIconSecondary: Color(0xFF747373),
    surfaceSecondary: Color(0xFF363636),
    strokeNeutral: Color(0xFF4D4D4D),
    surfacePrimaryInvert: Color(0xFFFFFFFF),
    textIconPrimaryInvert: Color(0xFF1C1C1C),
    strokeNeutralVariant: Color(0xFFB3B2B2),
    surfaceSecondaryVariant: Color(0xFF4E4E4E),
    textIconSecondaryVariant: Color(0xFFAAAAAA),
    surfacePrimaryVariant: Color(0xFFFFFFFF),
    surfaceTertiary: Color(0xFF444444),
    splashSvgGradient: LinearGradient(
      colors: [Color(0xFF1C1C1C), Color(0xFF3D3D3D)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    activeDay: Color(0xFFFF4400),
  );
}
