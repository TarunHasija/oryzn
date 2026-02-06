import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:oryzn/core/router/app_routes.dart';
import 'package:oryzn/core/theme/theme_provider.dart';
import 'package:oryzn/extensions/extensions.dart';
import 'package:oryzn/features/auth/riverpod/provider/auth_provider.dart';

import '../../../core/widgets/widgets.dart';
import '../../../gen/assets.gen.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();

    ref.listen(authProvider, (previous, next) {
      log(
        'Auth state changed: isAuthenticated=${next.isAuthenticated}, isLoading=${next.isLoading}, userId=${next.userId}',
        name: 'LoginView',
      );
      if (next.isAuthenticated && !next.isLoading) {
        log('Navigating to home...', name: 'LoginView');
        context.go(AppRoutes.home);
      }
    });
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
            top: 0,
            left: 0,
            right: 0,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height,
              ),
              child: SvgPicture.asset(
                fit: BoxFit.cover,
                Assets.images.dotBg,
                colorFilter: ColorFilter.mode(
                  ref.colors.surfacePrimaryInvert,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: 0,
            right: 0,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height,
              ),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return ref.colors.splashSvgGradient.createShader(bounds);
                },
                blendMode: BlendMode.srcIn,
                child: SvgPicture.asset(
                  fit: BoxFit.cover,
                  Assets.images.splashShapes,
                ),
              ),
            ),
          ),
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
                          height: 1,
                          fontSize: 64,
                          color: ref.colors.textIconPrimary,
                        ),
                      ),
                    ],
                  ),
                  Gap(92),
                  TextFormField(
                    controller: emailController,
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
                  Gap(24),
                  Bounceable(
                    onTap: () {},
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: ref.colors.surfacePrimaryInvert,
                      ),
                      width: double.infinity,
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

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60.0,
                      vertical: 32,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            height: 1,
                            color: ref.colors.textIconSecondaryVariant,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            "or",
                            style: context.labelLarge.copyWith(
                              color: ref.colors.textIconSecondaryVariant,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            height: 1,
                            color: ref.colors.textIconSecondaryVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    spacing: 32,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Bounceable(
                        onTap: () {
                          ref.read(authProvider.notifier).signInWithGoogle();
                        },
                        child: Column(
                          children: [
                            CustomIcon(
                              borderRadius: 16,
                              backgroundColor: ref.colors.surfaceSecondary,
                              asset: Assets.images.googleIcon,
                              size: 40,
                              padding: 12,
                            ),
                            Gap(8),
                            Text(
                              "Google",
                              style: context.labelLarge.copyWith(
                                color: ref.colors.textIconSecondaryVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Bounceable(
                        onTap: () {
                          ref.read(authProvider.notifier).signInAnonymously();
                        },
                        child: Column(
                          children: [
                            CustomIcon(
                              borderRadius: 16,
                              backgroundColor: ref.colors.surfaceSecondary,
                              icon: Icons.person_2_outlined,
                              size: 40,
                              padding: 12,
                            ),
                            Gap(8),
                            Text(
                              "Guest",
                              style: context.labelLarge.copyWith(
                                color: ref.colors.textIconSecondaryVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
