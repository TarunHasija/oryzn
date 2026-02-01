import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/gen/assets.gen.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/widgets.dart';
import '../../../extensions/extensions.dart';
import '../riverpod/riverpod.dart';

class MonthView extends ConsumerWidget {
  const MonthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// [home state]
    final homeState = ref.watch(homeProvider);

    /// [homeprovider]
    // final homeNotifier = ref.watch(homeProvider.notifier);
    return RepaintBoundary(
      child: GridView.builder(
        padding: 20.horizontalPadding,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: homeState.totalDaysInMonth,
        itemBuilder: (context, index) {
          final state = TimeUtils.getDayStateForMonth(
            index: index,
            todayDayInMonth: homeState.todayDayOfMonth,
          );

          return CustomIcon(
            size: 12,
            asset: Assets.images.icon01,
            color: TimeUtils.getColorForState(state, context, ref),
          );
        },
      ),
    );
    ;
  }
}
