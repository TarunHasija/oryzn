import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:oryzn/core/constants/app_assets.dart';
import 'package:oryzn/core/theme/theme_provider.dart';
import 'package:oryzn/gen/assets.gen.dart';

import '../../../extensions/extensions.dart';
import '../riverpod/provider/provider.dart';

class AvatarBottomSheet extends ConsumerWidget {
  const AvatarBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: ref.colors.surfaceSecondary,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(20),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: ref.colors.textIconPrimary.withAlpha(50),
                ),
              ),
              Gap(20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: AppAssets.avatars.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        ref.read(homeProvider.notifier).selectAvatar(index);
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: homeState.selectAvatarIndex == index
                                    ? ref.colors.textIconPrimary
                                    : Colors.transparent,
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image(
                                image: AppAssets.avatars[index].provider(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (homeState.selectAvatarIndex == index)
                            Positioned(
                              right: 8,
                              bottom: 8,
                              child: Container(
                                height: 14,
                                width: 14,
                                decoration: BoxDecoration(
                                  color: ref.colors.textIconPrimary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Gap(24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _ThemeToggle(
                  onToggle: () =>
                      ref.read(themeProvider.notifier).toggleTheme(),
                ),
              ),
              Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeToggle extends ConsumerWidget {
  final VoidCallback onToggle;

  const _ThemeToggle({required this.onToggle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        height: 58,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: ref.colors.surfacePrimary,
          borderRadius: BorderRadius.circular(24),
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
                  color: ref.colors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(12),
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
