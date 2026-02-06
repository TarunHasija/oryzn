import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:oryzn/gen/assets.gen.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/widgets.dart';
import '../../../extensions/extensions.dart';
import '../riverpod/riverpod.dart';

class YearView extends ConsumerWidget {
  const YearView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// [home state]
    final homeState = ref.watch(homeProvider);
    final daysLeftInYear = TimeUtils.getDaysLeftInYear().toString();
    final percentageLeft = TimeUtils.getPercentageLeftInYear().toString();

    /// [homeprovider]
    // final homeNotifier = ref.watch(homeProvider.notifier);
    return RepaintBoundary(
      child: Column(
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

                /// Rotating text showing percentage and days left in the year
                RotatingText(
                  texts: ['$percentageLeft% left', '$daysLeftInYear days left'],
                  style: context.bodyMedium,
                  pauseDuration: const Duration(seconds: 6),
                  transitionDuration: const Duration(milliseconds: 800),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              addAutomaticKeepAlives: true,
              padding: 20.horizontalPadding,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 16,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: homeState.totalDaysInYear,
              itemBuilder: (context, index) {
                final state = TimeUtils.getDayStateForYear(
                  index: index,
                  todayDayInYear: homeState.todayDayOfYear,
                );

                return CustomIcon(
                  size: 12,
                  asset: Assets.images.icon01,
                  color: TimeUtils.getColorForState(state, context, ref),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
