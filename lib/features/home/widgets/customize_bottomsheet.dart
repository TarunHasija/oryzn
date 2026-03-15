import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:oryzn/core/constants/app_assets.dart';
import 'package:oryzn/core/theme/theme_provider.dart';
import 'package:oryzn/core/widgets/custom_icon.dart';
import 'package:oryzn/features/home/widgets/widgets.dart';
import 'package:oryzn/gen/assets.gen.dart';

import '../../../extensions/extensions.dart';
import '../riverpod/provider/provider.dart';

class CustomizeBottomSheet extends ConsumerWidget {
  const CustomizeBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);

    return DraggableScrollableSheet(
      initialChildSize: 0.65, // default height
      minChildSize: 0.65,
      maxChildSize: .75, // max expansion
      expand: false,
      builder: (context, scrollController) {
        return Container(
          // height: MediaQuery.of(context).size.height * .56,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ThemeToggle(
                    onToggle: ref.read(themeProvider.notifier).toggleTheme,
                  ),
                ),
                Gap(32),
                TextDividerRow(text: "Change Display Icon"),

                /// Icon Grid
                _IconGrid(
                  selectedIndex: homeState.selectedIconIndex,
                  onTap: homeNotifier.selectIcon,
                ),
                Gap(24),
                TextDividerRow(text: "Color for Display Icon"),

                /// Display Colors Combined (Subtle + Pop)
                _CombinedColorGridSection(
                  subtleColors: AppAssets.subtleColors,
                  popColors: AppAssets.popColors,
                  defaultColor: ref.colors.surfacePrimaryInvert,
                  selectedColorIndex: homeState.selectedIconColor,
                  onTap: homeNotifier.selectIconColor,
                ),
                Gap(32),
                TextDividerRow(text: "Color for Current Day"),
                _ColorSection(
                  colors: AppAssets.activeDay,
                  colorIndexOffset: 1,
                  defaultColor: ref.colors.activeDay,
                  selectedColorIndex: homeState.selectedActiveColorIndex,
                  onTap: homeNotifier.selectActiveColorIndex,
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
      },
    );
  }
}

// ──────────────────────────────────────────
// Edit Hint Overlay
// ──────────────────────────────────────────

class EditHintOverlay extends ConsumerWidget {
  final VoidCallback? onDismiss;

  const EditHintOverlay({super.key, this.onDismiss});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onLongPress: () {
        _dismissHint();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) {
            return CustomizeBottomSheet();
          },
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Align(
        alignment: Alignment(0, 0.35),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: ref.colors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIcon(
                      asset: Assets.images.longPressIcon,
                      size: 32,
                      color: ref.colors.textIconPrimary,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Long press Anywhere to edit',
                      style: context.bodyMedium.copyWith(
                        color: ref.colors.textIconPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _dismissHint() {
    onDismiss?.call();
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    ? ref.colors.surfaceSecondary
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
  final List<Color> colors;
  final int colorIndexOffset;
  final Color? defaultColor;
  final int selectedColorIndex;
  final ValueChanged<int> onTap;

  const _ColorSection({
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
        Gap(8),
        SizedBox(
          height: 42,
          child: ListView.builder(
            clipBehavior: Clip.none,
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 16),
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
// Combined Color Section (2-row grid)
// ──────────────────────────────────────────

class _CombinedColorGridSection extends ConsumerWidget {
  final List<Color> subtleColors;
  final List<Color> popColors;
  final Color? defaultColor;
  final int selectedColorIndex;
  final ValueChanged<int> onTap;

  const _CombinedColorGridSection({
    required this.subtleColors,
    required this.popColors,
    this.defaultColor,
    required this.selectedColorIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We combine the colors to determine coordinates easily.
    // Index mapping logic:
    // 0 = default (if provided)
    // 1 to subtleLength = Subtle colors
    // subtleLength + 1 to subtleLength + popLength = Pop colors
    final hasDefault = defaultColor != null;
    final totalSubtle = subtleColors.length;
    final totalPop = popColors.length;

    // Create a unified list of configuration items to render in a grid
    final items = <_ColorGridItem>[];

    if (hasDefault) {
      items.add(_ColorGridItem(colorIndex: 0, color: defaultColor!));
    }

    for (int i = 0; i < totalSubtle; i++) {
      items.add(_ColorGridItem(colorIndex: i + 1, color: subtleColors[i]));
    }

    final popOffset = totalSubtle + 1;
    for (int i = 0; i < totalPop; i++) {
      items.add(_ColorGridItem(colorIndex: i + popOffset, color: popColors[i]));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(8),
        SizedBox(
          height: 90, // Enough height for 2 rows of 40px + spacing
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = selectedColorIndex == item.colorIndex;

              return GestureDetector(
                onTap: () => onTap(item.colorIndex),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: ShapeDecoration(
                    color: item.color,
                    shape: ContinuousRectangleBorder(
                      side: BorderSide(
                        color: isSelected
                            ? (item.colorIndex == 0
                                  ? ref.colors.strokeNeutral
                                  : ref.colors.textIconPrimary)
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

class _ColorGridItem {
  final int colorIndex;
  final Color color;

  _ColorGridItem({required this.colorIndex, required this.color});
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ChipButton(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            selectedColor: ref.colors.surfaceSecondary,
            unselectedColor: Colors.transparent,
            text: "24 hour",
            onTap: onToggle,
            isSelected: is24HourFormat,
          ),
          Gap(16),
          ChipButton(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            selectedColor: ref.colors.surfaceSecondary,
            unselectedColor: Colors.transparent,
            text: "12 hour",
            onTap: onToggle,
            isSelected: !is24HourFormat,
          ),
        ],
      ),
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
      padding: const EdgeInsets.only(bottom: 12.0, left: 16, right: 16),
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
