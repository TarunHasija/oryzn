import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:oryzn/core/constants/app_assets.dart';
import 'package:oryzn/core/services/storage_service.dart';
import 'package:oryzn/gen/assets.gen.dart';

import '../../../core/widgets/widgets.dart';
import '../../../extensions/extensions.dart';
import '../riverpod/provider/provider.dart';
import 'widgets.dart';

class MainAppBar extends ConsumerWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: 8.horizontalPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomIcon(
                size: 32,
                color: ref.colors.textIconPrimary,
                asset: Assets.images.foregroundIconSvg,
              ),
              Gap(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hola 👋🏻", style: context.bodyMedium),
                  Text(
                    StorageService.getUserName(),
                    style: context.titleLarge.copyWith(fontSize: 18,letterSpacing: 0),
                  ),
                ],
              ),
            ],
          ),
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
            child: CustomIcon.button(
              borderRadius: 100,
              onPressed: () {
                showModalBottomSheet(
                  isDismissible: true,
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: ref.colors.surfaceSecondary,
                  builder: (context) => const AvatarBottomSheet(),
                );
              },
              size: 44,
              asset: AppAssets
                  .avatars[ref.watch(
                    homeProvider.select((s) => s.selectAvatarIndex),
                  )]
                  .path,
            ),
          ),
        ],
      ),
    );
  }
}
