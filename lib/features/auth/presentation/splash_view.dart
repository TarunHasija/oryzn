import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oryzn/core/theme/theme_provider.dart';
import 'package:oryzn/extensions/extensions.dart';

import '../../../core/widgets/widgets.dart';
import '../../../gen/assets.gen.dart';

class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController _emailController = TextEditingController();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(themeProvider.notifier).toggleTheme();
        },
      ),
      backgroundColor: ref.colors.surfacePrimary,
      body: Stack(
        children: [
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIcon(
                        size: 50,
                        asset: Assets.images.foregroundIconSvg,
                        color: ref.colors.textIconPrimary,
                      ),
                      Text(
                        "RYZN",
                        style: context.titleLarge.copyWith(
                          fontSize: 64,
                          color: ref.colors.textIconPrimary,
                        ),
                      ),
                    ],
                  ),
                  Gap(92),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Enter your mail",
                      hintStyle: context.labelLarge.copyWith(
                        color: ref.colors.textIconSecondary,
                      ),
                      contentPadding: EdgeInsets.all(16),
                      filled: true,
                      fillColor: ref.colors.surfaceSecondary,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: ref.colors.strokeNeutral),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: ref.colors.strokeNeutralVariant,
                        ),
                      ),
                    ),
                  ),
                  Bounceable(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: ref.colors.surfacePrimaryInvert,
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          "Login",
                          style: context.labelLarge.copyWith(
                            color: ref.colors.textIconPrimaryInvert,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
