import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// The shared divider used throughout RestroPulse.
///
/// It preserves Material's divider parameters while providing one place for
/// future app-wide divider styling changes.
class AppDivider extends StatelessWidget {
  const AppDivider({
    this.height = AppSpacing.spaceLg,
    this.thickness = 1,
    this.indent,
    this.endIndent,
    this.color,
    super.key,
  }) : _isVertical = false,
       width = null;

  const AppDivider.vertical({
    this.width = AppSpacing.spaceLg,
    this.thickness = 1,
    this.indent,
    this.endIndent,
    this.color,
    super.key,
  }) : _isVertical = true,
       height = null;

  final bool _isVertical;
  final double? height;
  final double? width;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (_isVertical) {
      return VerticalDivider(
        width: width,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
        color: color,
      );
    }

    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }
}
