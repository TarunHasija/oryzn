import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/core/constants/app_assets.dart';
import 'package:oryzn/extensions/color_extension.dart';

enum DayState { past, today, future }

class TimeUtils {
  // ──────────────────────────────────────────
  // Year
  // ──────────────────────────────────────────

  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  static int daysInYear(int year) {
    return isLeapYear(year) ? 366 : 365;
  }

  static int dayOfYear() {
    final now = DateTime.now();
    final start = DateTime(now.year, 1, 1);
    return now.difference(start).inDays + 1;
  }

  static int getDaysLeftInYear() {
    final now = DateTime.now();
    final lastDayOfYear = DateTime(now.year, 12, 31);
    return lastDayOfYear.difference(now).inDays;
  }

  static int getPercentageLeftInYear() {
    final now = DateTime.now();
    final totalDays = daysInYear(now.year);
    final lastDayOfYear = DateTime(now.year, 12, 31);
    return lastDayOfYear.difference(now).inDays * 100 ~/ totalDays;
  }

  // ──────────────────────────────────────────
  // Month
  // ──────────────────────────────────────────

  static int daysInMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0).day;
  }

  static int dayOfMonth() {
    return DateTime.now().day;
  }

  static int getDaysLeftInMonth() {
    final now = DateTime.now();
    final totalDays = DateTime(now.year, now.month + 1, 0).day;
    return totalDays - now.day;
  }

  static int getPercentageLeftInMonth() {
    final now = DateTime.now();
    final totalDays = DateTime(now.year, now.month + 1, 0).day;
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    return lastDayOfMonth.difference(now).inDays * 100 ~/ totalDays;
  }

  // ──────────────────────────────────────────
  // Day
  // ──────────────────────────────────────────

  static int getHourLeftInDay() {
    return 24 - DateTime.now().hour;
  }

  static String getCurrentHourLeftInADay() {
    final now = DateTime.now();
    final eod = DateTime(now.year, now.month, now.day, 24, 00, 00);
    final diff = eod.difference(now);
    final totalMinutes = (diff.inSeconds / 60).ceil();
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }

  static int getPercentageLeftInDay() {
    final now = DateTime.now();
    final totalSeconds = 24 * 60 * 60;
    final eod = DateTime(now.year, now.month, now.day, 24, 0, 0);
    return eod.difference(now).inSeconds * 100 ~/ totalSeconds;
  }

  static String getHourAsset() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;

    final isHalfHour = minute >= 30;
    if (isHalfHour) {
      return 'assets/hours/hour_$hour.5.svg';
    } else {
      return 'assets/hours/hour_$hour.0.svg';
    }
  }

  // ──────────────────────────────────────────
  // Day State & Color
  // ──────────────────────────────────────────

  static DayState getDayStateForYear({
    required int index,
    required int todayDayInYear,
  }) {
    final dayNumber = index + 1;

    if (dayNumber < todayDayInYear) {
      return DayState.past;
    } else if (dayNumber == todayDayInYear) {
      return DayState.today;
    } else {
      return DayState.future;
    }
  }

  static DayState getDayStateForMonth({
    required int index,
    required int todayDayInMonth,
  }) {
    final dayNumber = index + 1;

    if (dayNumber < todayDayInMonth) {
      return DayState.past;
    } else if (dayNumber == todayDayInMonth) {
      return DayState.today;
    } else {
      return DayState.future;
    }
  }

  static Color getColorForState(
    DayState state,
    BuildContext context,
    WidgetRef ref,
    int selectedIconColorIndex,
  ) {
    switch (state) {
      case DayState.past:
        if (selectedIconColorIndex == 0) return ref.colors.surfacePrimaryInvert;
        if (selectedIconColorIndex <= AppAssets.subtleColors.length) {
          return AppAssets.subtleColors[selectedIconColorIndex - 1];
        }
        return AppAssets.popColors[selectedIconColorIndex -
            AppAssets.subtleColors.length -
            1];

      case DayState.today:
        return ref.colors.activeDay;

      case DayState.future:
        return ref.colors.surfaceTertiary;
    }
  }
}
