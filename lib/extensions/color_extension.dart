import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/core/constants/app_colors.dart';

/// [usage example]
/// In ConsumerWidget: ref.colors.surfacePrimary

extension AppColorsX on WidgetRef {
  AppColors get colors => watch(appColorsProvider);
}
