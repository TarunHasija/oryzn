import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:oryzn/core/constants/app_colors.dart';
import 'package:oryzn/core/widgets/widgets.dart';
import 'package:oryzn/extensions/color_extension.dart';
import 'package:oryzn/gen/assets.gen.dart';
import '../../../core/utils/utils.dart';
import '../../../extensions/extensions.dart';
import '../riverpod/riverpod.dart';

class DayView extends ConsumerWidget {
  const DayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// [home state]
    final homeState = ref.watch(homeProvider);
    final hourAsset = TimeUtils.getHourAsset();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEE, d MMM y').format(DateTime.now()),
                style: context.bodyMedium,
              ),
              homeState.is24HourFormat
                  ? Text(
                      DateFormat('HH:mm').format(DateTime.now()).toString(),
                      style: context.bodyMedium,
                    )
                  : Text(
                      DateFormat('h:mm a').format(DateTime.now()).toString(),
                      style: context.bodyMedium,
                    ),

              /// Rotating text showing percentage and days left in the year
              // RotatingText(
              //   texts: ['% left', ' days left'],
              //   style: context.bodyMedium,
              //   pauseDuration: const Duration(seconds: 6),
              //   transitionDuration: const Duration(milliseconds: 800),
              // ),
            ],
          ),
        ),
        Gap(8),
        Stack(
          alignment: AlignmentGeometry.topCenter,
          children: [
            CustomIcon(
              asset: Assets.hours.hourFull,
              size: 420,
              color: ref.colors.surfaceTertiary,
            ),
            CustomIcon(
              asset: hourAsset,
              size: 420,
              color: ref.colors.surfacePrimaryInvert,
            ),
          ],
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
                    color: ref.colors.surfacePrimaryInvert,
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
