import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/core/constants/app_assets.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/widgets.dart';
import '../../../extensions/extensions.dart';
import '../riverpod/riverpod.dart';
import '../widgets/widgets.dart';

class YearView extends ConsumerWidget {
  const YearView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalDaysInYear = ref.watch(
      homeProvider.select((s) => s.totalDaysInYear),
    );
    final todayDayOfYear = ref.watch(
      homeProvider.select((s) => s.todayDayOfYear),
    );
    final selectedIconIndex = ref.watch(
      homeProvider.select((s) => s.selectedIconIndex),
    );
    final selectedIconColor = ref.watch(
      homeProvider.select((s) => s.selectedIconColor),
    );
    final daysLeftInYear = TimeUtils.getDaysLeftInYear().toString();
    final percentageLeft = TimeUtils.getPercentageLeftInYear().toString();

    return Column(
      children: [
        TimeViewHeader(
          trailing: RotatingText(
            texts: ['$percentageLeft% left', '$daysLeftInYear days left'],
            style: context.bodyMedium,
            pauseDuration: const Duration(seconds: 6),
            transitionDuration: const Duration(milliseconds: 800),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: 20.horizontalPadding,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 16,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: totalDaysInYear,
            itemBuilder: (context, index) {
              final state = TimeUtils.getDayStateForYear(
                index: index,
                todayDayInYear: todayDayOfYear,
              );
              return Image.asset(
                AppAssets.displayIcons[selectedIconIndex],
                width: 16,
                height: 16,
                color: TimeUtils.getColorForState(
                  state,
                  context,
                  ref,
                  selectedIconColor,
                ),
                colorBlendMode: BlendMode.srcIn,
              );
            },
          ),
        ),
      ],
    );
  }
}
