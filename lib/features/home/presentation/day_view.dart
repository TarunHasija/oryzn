import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:oryzn/core/widgets/widgets.dart';
import 'package:oryzn/gen/assets.gen.dart';
import '../../../core/utils/utils.dart';
import '../../../extensions/extensions.dart';
import '../riverpod/riverpod.dart';
import '../widgets/widgets.dart';

class DayView extends ConsumerWidget {
  const DayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final is24HourFormat = ref.watch(
      homeProvider.select((s) => s.is24HourFormat),
    );
    final hourAsset = TimeUtils.getHourAsset();
    final now = DateTime.now();
    final percentageLeft = TimeUtils.getPercentageLeftInDay().toString();
    final currentTime = is24HourFormat
        ? DateFormat('HH:mm').format(now)
        : DateFormat('h:mm a').format(now);

    return Column(
      children: [
        TimeViewHeader(
          trailing: RotatingText(
            texts: ['$percentageLeft% Day left', currentTime],
            style: context.bodyMedium,
            pauseDuration: const Duration(seconds: 6),
            transitionDuration: const Duration(milliseconds: 800),
          ),
        ),
        Gap(8),
        LayoutBuilder(
          builder: (context, constraint) {
            return Stack(
              alignment: AlignmentGeometry.topCenter,
              children: [
                CustomIcon(
                  asset: Assets.hours.hourFull,
                  size: constraint.maxWidth * .84,
                  color: ref.colors.surfaceTertiary,
                ),
                CustomIcon(
                  asset: hourAsset,
                  size: constraint.maxWidth * .84,
                  color: TimeUtils.getColorForState(
                    DayState.past,
                    context,
                    ref,
                    ref.watch(homeProvider.select((s) => s.selectedIconColor)),
                  ),
                ),
              ],
            );
          },
        ),
        Gap(32),
        Text(
          TimeUtils.getCurrentHourLeftInADay(),
          style: context.bodyMedium.copyWith(
            fontSize: 40,
            wordSpacing: -12,
            color: ref.colors.textIconPrimary,
          ),
        ),
        Gap(2),
        Text(
          "Time left Today",
          style: context.bodyMedium.copyWith(
            fontSize: 18,
            color: ref.colors.textIconSecondaryVariant,
          ),
        ),
        Gap(32),
        Container(
          decoration: BoxDecoration(
            color: ref.colors.surfacePrimary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ref.colors.strokeNeutral, width: 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIcon(
                    icon: Icons.circle,
                    size: 16,
                    color: TimeUtils.getColorForState(
                      DayState.past,
                      context,
                      ref,
                      ref.watch(
                        homeProvider.select((s) => s.selectedIconColor),
                      ),
                    ),
                  ),
                  Gap(4),
                  Text(
                    "Time Passed",
                    style: context.labelMedium.copyWith(
                      letterSpacing: .1,
                      wordSpacing: -2,
                      color: ref.colors.textIconPrimary,
                    ),
                  ),
                ],
              ),
              Gap(12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIcon(
                    icon: Icons.circle,
                    size: 16,
                    color: ref.colors.surfaceTertiary,
                  ),
                  Gap(4),
                  Text(
                    "Time Left",
                    style: context.labelMedium.copyWith(
                      letterSpacing: .1,
                      wordSpacing: -2,
                      color: ref.colors.textIconPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
