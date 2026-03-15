import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:oryzn/core/constants/app_assets.dart';

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
        color: ref.colors.surfacePrimary,
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
                                width: 3,
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
                        ],
                      ),
                    );
                  },
                ),
              ),
              Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
