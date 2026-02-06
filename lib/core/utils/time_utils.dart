import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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

  /// Day of year (1–365/366)
  static int dayOfYear() {
    final now = DateTime.now();
    final start = DateTime(now.year, 1, 1);
    return now.difference(start).inDays + 1;
  }

  /// Days in month 28-31
  static int daysInMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0).day;
  }

  /// get day of month
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

  static int getHourLeftInDay() {
    return 24 - DateTime.now().hour;
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

  static String getCurrentHourLeftInADay() {
    final now = DateTime.now();
    final eod = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final diff = eod.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }
}
