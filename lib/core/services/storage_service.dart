import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:oryzn/core/constants/storage_key.dart';

class StorageService {
  static late Box _storageBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _storageBox = await Hive.openBox(StorageKey.storageBox);

    // Set a random user name if not already set
    if (_storageBox.get(StorageKey.userName) == null) {
      final names = [
        'Tony Stark',
        'James Bond',
        'Sherlock Holmes',
        'Jack Sparrow',
        'Eleven',
        'Superman',
        'Batman',
        'Spider-Man',
        'John Wick',
        'Thor',
        'Captain America',
        'Darth Vader',
        'Deadpool',
        'Harry Potter',
        'Optimus Prime',
        'Groot',
      ];
      final randomName = names[Random().nextInt(names.length)];
      await setUserName(randomName);
    }
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

  static Future<void> setSelectedIconIndex(int index) async {
    await _storageBox.put(StorageKey.selectedIconIndex, index);
  }

  static int getSelectedIconIndex() {
    return _storageBox.get(StorageKey.selectedIconIndex, defaultValue: 0);
  }

  static Future<void> setSelectedIconColor(int colorValue) async {
    await _storageBox.put(StorageKey.selectedIconColor, colorValue);
  }

  static int getSelectedIconColor() {
    return _storageBox.get(StorageKey.selectedIconColor, defaultValue: 0);
  }

  static Future<void> setSelectedActiveColorIndex(int index) async {
    await _storageBox.put(StorageKey.selectedActiveColorIndex, index);
  }

  static int getSelectedActiveColorIndex() {
    return _storageBox.get(StorageKey.selectedActiveColorIndex, defaultValue: 0);
  }

  static Future<void> setSelectedAvatarIndex(int index) async {
    await _storageBox.put(StorageKey.selectedAvatarIndex, index);
  }

  static int getSelectedAvatarIndex() {
    return _storageBox.get(StorageKey.selectedAvatarIndex, defaultValue: 0);
  }

  static bool getHasSeenEditHint() {
    return _storageBox.get(StorageKey.hasSeenEditHint, defaultValue: false);
  }

  static Future<void> setHasSeenEditHint(bool value) async {
    await _storageBox.put(StorageKey.hasSeenEditHint, value);
  }
}
