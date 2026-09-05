import 'package:flutter/material.dart';
import 'package:restropulse/gen/assets.gen.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

Widget appName({
  required BuildContext context,
  double? fontSize,
  Color? leadColor,
  bool? withIcon = false,
}) {
  return withIcon ?? false
      ? Semantics(
          label: 'RestroPulse',
          header: true,
          child: ExcludeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Assets.logo.applogo.path,
                  width: 42,
                  height: 42,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: AppSpacing.spaceXs),
                appName(context: context, fontSize: 22),
              ],
            ),
          ),
        )
      : Text.rich(
          TextSpan(
            text: 'Restro',
            children: const [
              TextSpan(
                text: 'Pulse',
                style: TextStyle(color: AppColors.primary),
              ),
            ],
          ),
          style: AppTypography.headlineMedium.copyWith(
            color: leadColor ?? AppColors.ink,
            fontSize: fontSize,
          ),
          semanticsLabel: 'RestroPulse',
        );
}
