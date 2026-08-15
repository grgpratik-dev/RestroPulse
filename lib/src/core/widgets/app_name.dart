import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

Widget appName({required BuildContext context, double? fontSize, Color? leadColor}) {
  return Text.rich(
    TextSpan(
      text: 'Restro',
      children: const [
        TextSpan(
          text: 'Pulse',
          style: TextStyle(color: AppColors.primary),
        ),
      ],
    ),
    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
      color:leadColor ?? Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      fontFamily: AppTypography.plusJakartaSansFontFamily,
    ),
    semanticsLabel: 'RestroPulse',
  );
}
