import 'dart:developer';
import 'dart:io';

import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

/// Prepares and pushes data used by the Android/iOS home widgets.
class WidgetService {
  WidgetService._();

  // Native widget identifiers used by `home_widget` update calls.
  static const List<String> _androidProviderNames = [
    'Year4x2WidgetProvider',
    'Year3x2WidgetProvider',
    'Year2x2WidgetProvider',
    'Year4x4WidgetProvider',
    'Month2x2WidgetProvider',
    'Month3x2WidgetProvider',
    'Month4x2WidgetProvider',
    'Month4x4WidgetProvider',
  ];
  static const String _iOSWidgetName = 'MyHomeWidget';
  static const String _iOSAppGroupId = 'group.homeScreenApp';

  // Shared keys read by native widget code.
  static const String keyDateText = 'widget_date_text';
  static const String keyDaysLeftText = 'widget_days_left_text';
  static const String keyMonthDaysLeftText = 'widget_month_days_left_text';

  /// Initializes widget bridge and performs an immediate refresh.
  static Future<void> init() async {
    try {
      if (Platform.isIOS) {
        // iOS widgets read shared values through this app group container.
        await HomeWidget.setAppGroupId(_iOSAppGroupId);
      }
      await refreshCountdownWidget();
    } catch (e, stackTrace) {
      log(
        'WidgetService init failed: $e',
        name: 'WidgetService',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Computes display strings and pushes them to platform widgets.
  static Future<void> refreshCountdownWidget() async {
    final now = DateTime.now();
    final dateText = DateFormat('EEEE, d MMMM yyyy').format(now);

    // "Days left" excludes today: Mar 7, 2026 => 299.
    final startOfTodayUtc = DateTime.utc(now.year, now.month, now.day);
    final startOfNextYearUtc = DateTime.utc(now.year + 1, 1, 1);
    final daysLeft = startOfNextYearUtc.difference(startOfTodayUtc).inDays - 1;
    final daysLeftText = '$daysLeft days left';
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final monthDaysLeft = daysInMonth - now.day;
    final monthDaysLeftText = '$monthDaysLeft days left';

    try {
      await HomeWidget.saveWidgetData<String>(keyDateText, dateText);
      await HomeWidget.saveWidgetData<String>(keyDaysLeftText, daysLeftText);
      await HomeWidget.saveWidgetData<String>(
        keyMonthDaysLeftText,
        monthDaysLeftText,
      );

      if (Platform.isAndroid) {
        for (final providerName in _androidProviderNames) {
          await HomeWidget.updateWidget(androidName: providerName);
        }
      } else if (Platform.isIOS) {
        await HomeWidget.updateWidget(iOSName: _iOSWidgetName);
      }
    } catch (e, stackTrace) {
      log(
        'Widget refresh failed: $e',
        name: 'WidgetService',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
