import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/core/services/storage_service.dart';
import 'package:oryzn/core/utils/utils.dart';
import 'package:oryzn/features/home/riverpod/state/home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier()
    : super(
        HomeState(showBottomEditHint: StorageService.getHasSeenEditHint()),
      ) {
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

      /// [Persisted preferences]
      selectedIconIndex: StorageService.getSelectedIconIndex(),
      selectedIconColor: StorageService.getSelectedIconColor(),
      selectedActiveColorIndex: StorageService.getSelectedActiveColorIndex(),
      selectAvatarIndex: StorageService.getSelectedAvatarIndex(),
    );
  }

  void selectTab(HomeTab index) {
    state = state.copyWith(selectedTab: index);
  }

  void toggleHourFormat() {
    state = state.copyWith(is24HourFormat: !state.is24HourFormat);
  }

  void selectIcon(int index) {
    state = state.copyWith(selectedIconIndex: index);
    StorageService.setSelectedIconIndex(index);
  }

  void selectIconColor(int index) {
    state = state.copyWith(selectedIconColor: index);
    StorageService.setSelectedIconColor(index);
  }

  void selectActiveColorIndex(int index) {
    state = state.copyWith(selectedActiveColorIndex: index);
    StorageService.setSelectedActiveColorIndex(index);
  }

  void selectAvatar(int index) {
    state = state.copyWith(selectAvatarIndex: index);
    StorageService.setSelectedAvatarIndex(index);
  }

  void setBottomEditHint(bool value) {
    StorageService.setHasSeenEditHint(value);

    state = state.copyWith(showBottomEditHint: value);
  }
}
