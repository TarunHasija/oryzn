import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/core/utils/utils.dart';
import 'package:oryzn/features/home/riverpod/state/home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState()) {
    _initialize();
  }

  void _initialize() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    state = state.copyWith(
      /// [Year data]

      // Total Days in year
      totalDaysInYear: TimeUtils.daysInYear(year),
      // Todays day
      todayDayOfYear: TimeUtils.dayOfYear(now),

      /// [Month data]
      currentMonth: month,
      totalDaysInMonth: TimeUtils.daysInMonth(year, month),
      todayDayOfMonth: TimeUtils.dayOfMonth(now),
    );
  }

  void selectTab(HomeTab index) {
    state = state.copyWith(selectedTab: index);
  }
}
