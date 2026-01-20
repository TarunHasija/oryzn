import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:oryzn/core/router/app_routes.dart';
import 'package:oryzn/core/services/storage_service.dart';
import 'package:oryzn/core/theme/theme_provider.dart';
import 'package:oryzn/extensions/extensions.dart';

import '../../../core/widgets/widgets.dart';
import '../../../gen/assets.gen.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Check local storage - works offline
    final isLoggedIn = StorageService.getUserLoggedIn();
    if (isLoggedIn) {
      context.go(AppRoutes.home);
    } else {
      // change to home screen
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            top: 0,
            left: 0,
            bottom: 50,
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIcon(
                  size: 50,
                  asset: Assets.images.foregroundIconSvg,
                  color: ref.colors.textIconPrimary,
                ),
                Gap(2),
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
          ),
        ],
      ),
    );
  }
}
