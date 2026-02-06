import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/core/utils/utils.dart';
import 'package:oryzn/features/home/riverpod/state/home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState()) {
    _initialize();
  }

  void _initialize() {
    state = state.copyWith(
      /// [Year data]
      totalDaysInYear: TimeUtils.daysInYear(DateTime.now().year),
      todayDayOfYear: TimeUtils.dayOfYear(),

      /// [Month data]
      currentMonth: DateTime.now().month,
      totalDaysInMonth: TimeUtils.daysInMonth(),
      todayDayOfMonth: TimeUtils.dayOfMonth(),
    );
  }

  void selectTab(HomeTab index) {
    state = state.copyWith(selectedTab: index);
  }

  void toggleHourFormat() {
    state = state.copyWith(is24HourFormat: !state.is24HourFormat);
  }
}
