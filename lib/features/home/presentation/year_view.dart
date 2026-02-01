import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    /// [homeprovider]
    // final homeNotifier = ref.watch(homeProvider.notifier);
    return RepaintBoundary(
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
    );
    ;
  }
}
