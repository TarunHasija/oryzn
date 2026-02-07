import 'package:flutter/material.dart';
import 'package:oryzn/gen/assets.gen.dart';

class AppAssets {
  AppAssets._();

  /// Display icons (PNGs used in grid views)
  static const List<String> displayIcons = [
    'assets/images/icons/icon_01.png',
    'assets/images/icons/icon_21.png',
    'assets/images/icons/icon_02.png',
    'assets/images/icons/icon_03.png',
    'assets/images/icons/icon_04.png',
    'assets/images/icons/icon_05.png',
    'assets/images/icons/icon_06.png',
    'assets/images/icons/icon_07.png',
    'assets/images/icons/icon_08.png',
    'assets/images/icons/icon_09.png',
    'assets/images/icons/icon_10.png',
    'assets/images/icons/icon_11.png',
    'assets/images/icons/icon_12.png',
    // 'assets/images/icons/icon_13.png',
    'assets/images/icons/icon_14.png',
    'assets/images/icons/icon_15.png',
    'assets/images/icons/icon_16.png',
    'assets/images/icons/icon_17.png',
    'assets/images/icons/icon_18.png',
    'assets/images/icons/icon_19.png',
    'assets/images/icons/icon_20.png',
  ];

  /// Avatars (PNGs)
  static final List<AssetGenImage> avatars = [
    Assets.images.avatars.avatar16,
    Assets.images.avatars.avatar1,
    Assets.images.avatars.avatar2,
    Assets.images.avatars.avatar3,
    Assets.images.avatars.avatar4,
    Assets.images.avatars.avatar5,
    Assets.images.avatars.avatar6,
    Assets.images.avatars.avatar7,
    Assets.images.avatars.avatar8,
    Assets.images.avatars.avatar9,
    Assets.images.avatars.avatar10,
    Assets.images.avatars.avatar11,
    Assets.images.avatars.avatar12,
    Assets.images.avatars.avatar13,
    Assets.images.avatars.avatar14,
    Assets.images.avatars.avatar15,
  ];

  /// Subtle rainbow color palette
  static const List<Color> subtleColors = [
    Color(0xFFFFADAD),
    Color(0xFFFFD6A5),
    Color(0xFFFDFFB6),
    Color(0xFFCAFFBF),
    Color(0xFF9BF6FF),
    Color(0xFFA0C4FF),
    Color(0xFFBDB2FF),
    Color(0xFFFFC6FF),
  ];

  /// Pop color palette
  static const List<Color> popColors = [
    Color(0xFFFF70A6),
    Color(0xFF70D6FF),
    Color(0xFFE9FF70),
    Color(0xFF9381FF),
    Color(0xFFFFD670),
    Color(0xFFFF9770),
    Color(0xFFC1FF9B),
    Color(0xFFFF5C5C),
    Color(0xFF74DFC4),
    Color(0xFFE66789),
  ];
}
