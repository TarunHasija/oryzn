import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/core/constants/app_colors.dart';
import 'package:oryzn/core/widgets/widgets.dart';
import 'package:oryzn/extensions/color_extension.dart';
import 'package:oryzn/gen/assets.gen.dart';
import '../../../core/utils/utils.dart';
import '../riverpod/riverpod.dart';

class DayView extends ConsumerWidget {
  const DayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// [home state]
    final homeState = ref.watch(homeProvider);
    final now = DateTime.now();
    final hourAsset = TimeUtils.getHourAsset(now);

    return Stack(
      alignment: AlignmentGeometry.topCenter,
      children: [
        CustomIcon(
          asset: Assets.hours.hourFull,
          size: 500,
          color: ref.colors.surfaceTertiary,
        ),
        CustomIcon(
          asset: hourAsset,
          size: 500,
          color: ref.colors.surfacePrimaryInvert,
        ),
      ],
    );
  }
}
