import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/extensions/color_extension.dart';

/// Enum for visual date showing
enum DayState { past, today, future }

class TimeUtils {
  /// Leap year check
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Total days in year
  static int daysInYear(int year) {
    return isLeapYear(year) ? 366 : 365;
  }

  /// Day of year (1–365/366)
  static int dayOfYear(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    return date.difference(start).inDays + 1;
  }

  static DayState getDayState({
    required int index,
    required int todayDayOfYear,
  }) {
    final dayNumber = index + 1;

    if (dayNumber < todayDayOfYear) {
      return DayState.past;
    } else if (dayNumber == todayDayOfYear) {
      return DayState.today;
    } else {
      return DayState.future;
    }
  }

  static Color getColorForState(
    DayState state,
    BuildContext context,
    WidgetRef ref,
  ) {
    switch (state) {
      case DayState.past:
        return ref.colors.surfacePrimaryInvert;

      case DayState.today:
        return ref.colors.activeDay;

      case DayState.future:
        return ref.colors.surfaceTertiary;
    }
  }
}
