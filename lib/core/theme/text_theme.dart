import 'package:flutter/material.dart';
import 'package:oryzn/core/constants/app_colors.dart';

const _regular = FontWeight.w400;
// const _medium = FontWeight.w500;
const _semiBold = FontWeight.w600;
const _bold = FontWeight.w700;

TextTheme buildTextTheme(AppColors colors) {
  return TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Space Mono',
      fontWeight: _regular,
      fontSize: 57,
      color: colors.textIconPrimary,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Space Mono',
      fontWeight: _regular,
      fontSize: 45,
      color: colors.textIconPrimary,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Space Mono',
      fontWeight: _regular,
      fontSize: 36,
      color: colors.textIconPrimary,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Space Mono',
      fontWeight: _semiBold,
      fontSize: 32,
      color: colors.textIconPrimary,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Space Mono',
      fontWeight: _regular,
      fontSize: 28,
      color: colors.textIconPrimary,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Space Mono',
      fontWeight: _regular,
      fontSize: 24,
      color: colors.textIconPrimary,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Space Mono',
      fontWeight: _regular,
      fontSize: 22,
      color: colors.textIconPrimary,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Space Mono',
      fontWeight: _bold,
      fontSize: 16,
      color: colors.textIconPrimary,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Space Mono',
      fontWeight: _regular,
      fontSize: 14,
      color: colors.textIconPrimary,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Space Mono',
      fontWeight: _regular,
      fontSize: 16,
      color: colors.textIconPrimary,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Space Mono',
      fontWeight: _regular,
      fontSize: 14,
      color: colors.textIconPrimary,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Space Mono',
      fontWeight: _regular,
      fontSize: 12,
      color: colors.textIconSecondary,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Space Mono',
      fontWeight: _regular,
      fontSize: 14,
      color: colors.textIconPrimary,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Space Mono',
      fontWeight: _regular,
      fontSize: 12,
      color: colors.textIconPrimary,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Space Mono',
      fontWeight: _regular,
      fontSize: 11,
      color: colors.textIconSecondary,
    ),
  );
}
