import 'package:flutter/material.dart';

import '../themes/app_radii.dart';

/// DevClayPOS brand mark from [assets/branding/app_icon.png].
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 36,
    this.borderRadius,
  });

  static const String assetPath = 'assets/branding/app_icon.png';

  final double size;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? AppRadii.smAll,
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
