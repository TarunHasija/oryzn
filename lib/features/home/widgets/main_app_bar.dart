import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:oryzn/core/theme/theme_provider.dart';
import 'package:oryzn/gen/assets.gen.dart';

import '../../../core/widgets/widgets.dart';
import '../../../extensions/extensions.dart';

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
              Gap(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hola 👋🏻", style: context.bodyMedium),
                  Text(
                    "Tarun",
                    style: context.titleLarge.copyWith(fontSize: 18),
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
                ref.read(themeProvider.notifier).toggleTheme();
              },
              size: 44,
              asset: Assets.images.avatar16.path,
            ),
          ),
        ],
      ),
    );
  }
}
