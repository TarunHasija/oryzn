import 'dart:developer';
import 'dart:io';

import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

class WidgetService {
  WidgetService._();

  static const String _androidProviderName = 'OryznHomeWidgetProvider';
  static const String _iOSWidgetName = 'MyHomeWidget';
  static const String _iOSAppGroupId = 'group.homeScreenApp';

  static const String keyDateText = 'widget_date_text';
  static const String keyDaysLeftText = 'widget_days_left_text';

  static Future<void> init() async {
    try {
      if (Platform.isIOS) {
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

  static Future<void> refreshCountdownWidget() async {
    final now = DateTime.now();
    final dateText = DateFormat('EEEE, d MMMM yyyy').format(now);

    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfNextYear = DateTime(now.year + 1, 1, 1);
    final daysLeft = startOfNextYear.difference(startOfToday).inDays;
    final daysLeftText = '$daysLeft days left';

    try {
      await HomeWidget.saveWidgetData<String>(keyDateText, dateText);
      await HomeWidget.saveWidgetData<String>(keyDaysLeftText, daysLeftText);

      if (Platform.isAndroid) {
        await HomeWidget.updateWidget(androidName: _androidProviderName);
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
