import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/core/constants/app_assets.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/widgets.dart';
import '../../../extensions/extensions.dart';
import '../riverpod/riverpod.dart';
import '../widgets/widgets.dart';

class MonthView extends ConsumerWidget {
  const MonthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalDaysInMonth = ref.watch(
      homeProvider.select((s) => s.totalDaysInMonth),
    );
    final todayDayOfMonth = ref.watch(
      homeProvider.select((s) => s.todayDayOfMonth),
    );
    final selectedIconIndex = ref.watch(
      homeProvider.select((s) => s.selectedIconIndex),
    );
    final selectedIconColor = ref.watch(
      homeProvider.select((s) => s.selectedIconColor),
    );
    final daysLeftInMonth = TimeUtils.getDaysLeftInMonth().toString();
    final percentageLeft = TimeUtils.getPercentageLeftInMonth().toString();

    return Column(
      children: [
        TimeViewHeader(
          trailing: RotatingText(
            texts: ['$percentageLeft% left', '$daysLeftInMonth days left'],
            style: context.bodyMedium,
            pauseDuration: const Duration(seconds: 6),
            transitionDuration: const Duration(milliseconds: 800),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: 20.horizontalPadding,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: totalDaysInMonth,
            itemBuilder: (context, index) {
              final state = TimeUtils.getDayStateForMonth(
                index: index,
                todayDayInMonth: todayDayOfMonth,
              );

              return Image.asset(
                AppAssets.displayIcons[selectedIconIndex],
                width: 12,
                height: 12,
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
