import 'package:hive_flutter/hive_flutter.dart';
import 'package:oryzn/core/constants/storage_key.dart';

class StorageService {
  static late Box _storageBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _storageBox = await Hive.openBox(StorageKey.storageBox);
  }

  static bool getIsDarkMode() {
    return _storageBox.get(StorageKey.theme, defaultValue: false);
  }

  static Future<void> setIsDarkMode(bool isDark) async {
    await _storageBox.put(StorageKey.theme, isDark);
  }

  static Future<void> setUserLoggedIn(bool isLoggedIn) async {
    await _storageBox.put(StorageKey.userLoggedIn, isLoggedIn);
  }

  static bool getUserLoggedIn() {
    return _storageBox.get(StorageKey.userLoggedIn, defaultValue: false);
  }

  static Future<void> setUserName(String userName) async {
    await _storageBox.put(StorageKey.userName, userName);
  }

  static String getUserName() {
    return _storageBox.get(StorageKey.userName, defaultValue: 'User');
  }
}
