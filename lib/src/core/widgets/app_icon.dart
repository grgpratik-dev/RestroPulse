import 'package:flutter/material.dart';
import 'package:restropulse/src/core/widgets/app_svg_icon.dart';

/// RestroPulse's SVG replacement for Material's [Icon] widget.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.asset, {
    this.size,
    this.color,
    this.semanticLabel,
    super.key,
  });

  final String asset;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    return AppSvgIcon(
      asset: asset,
      // 24px is the standard control icon size. AppSvgIcon centers it inside
      // larger layout/touch slots without stretching the artwork.
      size: size ?? 24,
      color: color ?? iconTheme.color,
      semanticLabel: semanticLabel,
    );
  }
}
