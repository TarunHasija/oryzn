import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:oryzn/core/theme/theme_provider.dart';
import 'package:oryzn/extensions/color_extension.dart';
import 'package:oryzn/extensions/style_extension.dart';
import 'package:oryzn/gen/assets.gen.dart';

class ThemeToggle extends ConsumerWidget {
  final VoidCallback onToggle;

  const ThemeToggle({super.key, required this.onToggle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        height: 58,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: ref.colors.surfaceSecondary,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: isDark ? Alignment.centerLeft : Alignment.centerRight,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                width: MediaQuery.of(context).size.width / 2 - 24,
                height: 34,
                decoration: BoxDecoration(
                  color: ref.colors.surfaceTertiary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          Assets.images.nightLottie,
                          width: 24,
                          height: 24,
                        ),
                        Gap(8),
                        Text(
                          "Dark",
                          style: context.labelLarge.copyWith(
                            color: ref.colors.textIconPrimary,
                          ),
                        ),
                        Gap(12),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          Assets.images.sunnyLottie,
                          width: 24,
                          height: 24,
                        ),
                        Gap(8),
                        Text(
                          "Light",
                          style: context.labelLarge.copyWith(
                            color: ref.colors.textIconPrimary,
                          ),
                        ),
                        Gap(12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
