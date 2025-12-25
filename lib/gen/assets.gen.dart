// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/dotted_bg.png
  AssetGenImage get dottedBg =>
      const AssetGenImage('assets/images/dotted_bg.png');

  /// File path: assets/images/icon_01.svg
  String get icon01 => 'assets/images/icon_01.svg';

  /// File path: assets/images/icon_02.svg
  String get icon02 => 'assets/images/icon_02.svg';

  /// File path: assets/images/icon_03.svg
  String get icon03 => 'assets/images/icon_03.svg';

  /// File path: assets/images/icon_04.svg
  String get icon04 => 'assets/images/icon_04.svg';

  /// File path: assets/images/icon_05.svg
  String get icon05 => 'assets/images/icon_05.svg';

  /// File path: assets/images/icon_06.svg
  String get icon06 => 'assets/images/icon_06.svg';

  /// File path: assets/images/icon_07.svg
  String get icon07 => 'assets/images/icon_07.svg';

  /// File path: assets/images/icon_08.svg
  String get icon08 => 'assets/images/icon_08.svg';

  /// File path: assets/images/icon_09.svg
  String get icon09 => 'assets/images/icon_09.svg';

  /// File path: assets/images/icon_10.svg
  String get icon10 => 'assets/images/icon_10.svg';

  /// File path: assets/images/icon_11.svg
  String get icon11 => 'assets/images/icon_11.svg';

  /// File path: assets/images/icon_12.svg
  String get icon12 => 'assets/images/icon_12.svg';

  /// File path: assets/images/icon_13.svg
  String get icon13 => 'assets/images/icon_13.svg';

  /// File path: assets/images/icon_14.svg
  String get icon14 => 'assets/images/icon_14.svg';

  /// File path: assets/images/icon_15.svg
  String get icon15 => 'assets/images/icon_15.svg';

  /// File path: assets/images/icon_16.svg
  String get icon16 => 'assets/images/icon_16.svg';

  /// File path: assets/images/icon_17.svg
  String get icon17 => 'assets/images/icon_17.svg';

  /// File path: assets/images/icon_18.svg
  String get icon18 => 'assets/images/icon_18.svg';

  /// File path: assets/images/icon_19.svg
  String get icon19 => 'assets/images/icon_19.svg';

  /// File path: assets/images/icon_20.svg
  String get icon20 => 'assets/images/icon_20.svg';

  /// File path: assets/images/icon_21.svg
  String get icon21 => 'assets/images/icon_21.svg';

  /// File path: assets/images/shapes.png
  AssetGenImage get shapes => const AssetGenImage('assets/images/shapes.png');

  /// List of all assets
  List<dynamic> get values => [
    dottedBg,
    icon01,
    icon02,
    icon03,
    icon04,
    icon05,
    icon06,
    icon07,
    icon08,
    icon09,
    icon10,
    icon11,
    icon12,
    icon13,
    icon14,
    icon15,
    icon16,
    icon17,
    icon18,
    icon19,
    icon20,
    icon21,
    shapes,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
