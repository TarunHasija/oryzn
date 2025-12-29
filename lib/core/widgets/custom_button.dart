import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';

class CustomIcon extends StatelessWidget {
  final double size;
  final double padding;
  final Color? color;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final double borderRadius;
  final IconData? icon;
  final String? imageUrl;
  final String? asset;

  const CustomIcon({
    super.key,
    this.icon,
    this.asset,
    this.imageUrl,
    this.size = 18,
    this.padding = 0,
    this.color,
    this.foregroundColor,
    this.backgroundColor,
    this.borderRadius = double.maxFinite,
  }) : assert(
         icon != null || imageUrl != null || asset != null,
         'At least one icon source must be provided',
       );

  @override
  Widget build(BuildContext context) {
    Widget? iconWidget;

    if (icon != null) {
      iconWidget = Icon(icon, size: size, color: color);
    } else if (asset != null) {
      iconWidget = _buildAssetIcon();
    }

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: iconWidget,
    );
  }

  Widget _buildAssetIcon() {
    if (asset!.endsWith('.svg')) {
      return SvgPicture.asset(
        asset!,
        width: size,
        height: size,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
      );
    } else {
      return Image.asset(
        asset!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        color: color,
      );
    }
  }

  static Widget button({
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    IconData? icon,
    String? imageUrl,
    String? asset,
    double size = 24,
    double padding = 0,
    Color? color,
    Color? foregroundColor,
    Color? backgroundColor,
    double borderRadius = double.maxFinite,
  }) {
    final iconWidget = CustomIcon(
      icon: icon,
      imageUrl: imageUrl,
      asset: asset,
      size: size,
      padding: padding,
      color: color,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
    );

    return Bounceable(
      onTap: onPressed,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: iconWidget,
      ),
    );
  }
}
