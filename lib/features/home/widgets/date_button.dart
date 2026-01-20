import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/extensions.dart';

class DateButton extends ConsumerWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;
  const DateButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 80,
      height: 36,
      child: AnimatedScale(
        scale: isSelected ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 250),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: isSelected
                  ? ref.colors.surfaceSecondary
                  : ref.colors.surfacePrimary,
              borderRadius: BorderRadius.circular(isSelected ? 30 : 12),
              border: Border.all(
                color: isSelected
                    ? ref.colors.strokeNeutralVariant
                    : ref.colors.strokeNeutral,
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: context.labelLarge.copyWith(
                  fontSize: isSelected ? 15 : 14,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
