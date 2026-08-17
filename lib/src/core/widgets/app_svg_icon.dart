import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Consistent renderer for product-specific SVG assets.
class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon({
    required this.asset,
    this.size = 24,
    this.color,
    this.semanticLabel,
    super.key,
  });

  final String asset;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? IconTheme.of(context).color;
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: SvgPicture.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.contain,
        semanticsLabel: semanticLabel,
        excludeFromSemantics: semanticLabel == null,
        colorFilter: resolvedColor == null
            ? null
            : ColorFilter.mode(resolvedColor, BlendMode.srcIn),
      ),
    );
  }
}
