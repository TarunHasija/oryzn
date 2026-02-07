import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../extensions/extensions.dart';
import '../../gen/assets.gen.dart';

class AuthBackground extends ConsumerWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenHeight),
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
            constraints: BoxConstraints(maxHeight: screenHeight),
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
        child,
      ],
    );
  }
}
