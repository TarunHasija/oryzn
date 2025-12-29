import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/core/constants/app_colors.dart';

/// [usage example]
// color : context.colors.surfacePrimary

extension AppColorsX on BuildContext {
  AppColors get colors {
    return ProviderScope.containerOf(this).read(appColorsProvider);
  }
}
