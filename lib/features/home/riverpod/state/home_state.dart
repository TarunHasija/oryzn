enum HomeTab { year, month, day }

class HomeState {
  final HomeTab selectedTab;

  // Year data
  final int todayDayOfYear;
  final int totalDaysInYear;

  // Month data
  final int currentMonth; // 1-12
  final int todayDayOfMonth; // 1-31
  final int totalDaysInMonth; // 28-31

  const HomeState({
    this.selectedTab = HomeTab.year,
    this.todayDayOfYear = 0,
    this.totalDaysInYear = 365,
    this.currentMonth = 1,
    this.todayDayOfMonth = 1,
    this.totalDaysInMonth = 31,
  });

  HomeState copyWith({
    HomeTab? selectedTab,
    int? todayDayOfYear,
    int? totalDaysInYear,
    int? currentMonth,
    int? todayDayOfMonth,
    int? totalDaysInMonth,
  }) {
    return HomeState(
      selectedTab: selectedTab ?? this.selectedTab,
      todayDayOfYear: todayDayOfYear ?? this.todayDayOfYear,
      totalDaysInYear: totalDaysInYear ?? this.totalDaysInYear,
      currentMonth: currentMonth ?? this.currentMonth,
      todayDayOfMonth: todayDayOfMonth ?? this.todayDayOfMonth,
      totalDaysInMonth: totalDaysInMonth ?? this.totalDaysInMonth,
    );
  }
}
