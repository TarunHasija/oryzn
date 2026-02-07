import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/extensions.dart';

class ChipButton extends ConsumerWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;
  final double selectedBorderRadius;
  final double unselectedBorderRadius;
  final TextStyle? textStyle;

  const ChipButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.isSelected,
    this.width = 80,
    this.height = 36,
    this.padding,
    this.selectedColor,
    this.unselectedColor,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.selectedBorderRadius = 30,
    this.unselectedBorderRadius = 12,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final container = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: padding ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isSelected
            ? (selectedColor ?? ref.colors.surfaceSecondary)
            : (unselectedColor ?? ref.colors.surfacePrimary),
        borderRadius: BorderRadius.circular(
          isSelected ? selectedBorderRadius : unselectedBorderRadius,
        ),
        border: Border.all(
          color: isSelected
              ? (selectedBorderColor ?? ref.colors.strokeNeutralVariant)
              : (unselectedBorderColor ?? ref.colors.strokeNeutral),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style:
              textStyle ??
              context.labelLarge.copyWith(
                fontSize: isSelected ? 15 : 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
        ),
      ),
    );

    Widget child = padding != null
        ? container
        : SizedBox(width: width, height: height, child: container);

    return AnimatedScale(
      scale: isSelected ? 1.08 : 1.0,
      duration: const Duration(milliseconds: 250),
      child: GestureDetector(onTap: onTap, child: child),
    );
  }
}
