import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:oryzn/core/constants/app_assets.dart';
import 'package:oryzn/core/widgets/custom_icon.dart';
import 'package:oryzn/features/home/widgets/widgets.dart';

import '../../../extensions/extensions.dart';
import '../riverpod/provider/provider.dart';

class CustomizeBottomSheet extends ConsumerWidget {
  const CustomizeBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextDividerRow(text: "Change Display Icon"),

            /// Icon Grid
            _IconGrid(
              selectedIndex: homeState.selectedIconIndex,
              onTap: homeNotifier.selectIcon,
            ),
            Gap(24),
            TextDividerRow(text: "Color for Display Icon"),

            /// Subtle Colors
            _ColorSection(
              label: "Subtle",
              colors: AppAssets.subtleColors,
              colorIndexOffset: 1,
              defaultColor: ref.colors.surfacePrimaryInvert,
              selectedColorIndex: homeState.selectedIconColor,
              onTap: homeNotifier.selectIconColor,
            ),
            Gap(16),

            /// Pop Colors
            _ColorSection(
              label: "Pop",
              colors: AppAssets.popColors,
              colorIndexOffset: AppAssets.subtleColors.length + 1,
              selectedColorIndex: homeState.selectedIconColor,
              onTap: homeNotifier.selectIconColor,
            ),
            Gap(32),

            /// Clock Format
            TextDividerRow(text: "Clock Format"),
            _ClockFormatSection(
              is24HourFormat: homeState.is24HourFormat,
              onToggle: homeNotifier.toggleHourFormat,
            ),
            Gap(40),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
// Icon Grid
// ──────────────────────────────────────────

class _IconGrid extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _IconGrid({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 140,
      child: GridView.builder(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: AppAssets.displayIcons.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              margin: EdgeInsets.all(1),
              decoration: ShapeDecoration(
                color: isSelected
                    ? ref.colors.surfaceSecondaryVariant
                    : Colors.transparent,
                shape: ContinuousRectangleBorder(
                  side: BorderSide(color: ref.colors.strokeNeutral, width: 1),
                  borderRadius: BorderRadius.circular(36),
                ),
              ),
              height: 60,
              width: 60,
              padding: EdgeInsets.all(10),
              child: CustomIcon(
                asset: AppAssets.displayIcons[index],
                color: ref.colors.surfacePrimaryVariant,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ──────────────────────────────────────────
// Color Section (label + swatch list)
// ──────────────────────────────────────────

class _ColorSection extends ConsumerWidget {
  final String label;
  final List<Color> colors;
  final int colorIndexOffset;
  final Color? defaultColor;
  final int selectedColorIndex;
  final ValueChanged<int> onTap;

  const _ColorSection({
    required this.label,
    required this.colors,
    required this.colorIndexOffset,
    this.defaultColor,
    required this.selectedColorIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasDefault = defaultColor != null;
    final itemCount = colors.length + (hasDefault ? 1 : 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.bodySmall.copyWith(color: ref.colors.textIconPrimary),
        ),
        Gap(8),
        SizedBox(
          height: 42,
          child: ListView.builder(
            clipBehavior: Clip.none,
            padding: EdgeInsets.symmetric(vertical: 1),
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final int colorIndex;
              final Color color;

              if (hasDefault && index == 0) {
                colorIndex = 0;
                color = defaultColor!;
              } else {
                final listIndex = hasDefault ? index - 1 : index;
                colorIndex = listIndex + colorIndexOffset;
                color = colors[listIndex];
              }

              final isSelected = selectedColorIndex == colorIndex;

              return GestureDetector(
                onTap: () => onTap(colorIndex),
                child: Container(
                  margin: EdgeInsets.only(right: 8),
                  width: 40,
                  height: 40,
                  decoration: ShapeDecoration(
                    color: color,
                    shape: ContinuousRectangleBorder(
                      side: BorderSide(
                        color: isSelected
                            ? ref.colors.textIconPrimary
                            : ref.colors.strokeNeutral,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────
// Clock Format
// ──────────────────────────────────────────

class _ClockFormatSection extends ConsumerWidget {
  final bool is24HourFormat;
  final VoidCallback onToggle;

  const _ClockFormatSection({
    required this.is24HourFormat,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        ChipButton(
          unselectedBorderRadius: 8,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          selectedColor: ref.colors.surfaceSecondaryVariant,
          unselectedColor: ref.colors.surfaceSecondary,
          text: "24 hour",
          onTap: onToggle,
          isSelected: is24HourFormat,
        ),
        Gap(16),
        ChipButton(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          selectedColor: ref.colors.surfaceSecondaryVariant,
          unselectedColor: ref.colors.surfaceSecondary,
          text: "12 hour",
          onTap: onToggle,
          isSelected: !is24HourFormat,
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────
// Text Divider Row
// ──────────────────────────────────────────

class TextDividerRow extends ConsumerWidget {
  final String text;
  const TextDividerRow({super.key, required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Text(text, style: context.titleMedium),
          Gap(10),
          Expanded(child: Divider(height: 1, color: ref.colors.strokeNeutral)),
        ],
      ),
    );
  }
}
