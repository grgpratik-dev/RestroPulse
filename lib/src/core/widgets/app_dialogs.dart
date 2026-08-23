import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restropulse/gen/assets.gen.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';

class AppDialogs {
  static void fullLoadingDialog({String? data, required BuildContext context}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.kNeutral800.withValues(alpha: 0.2),
      // barrierLabel: data ?? "....",
      pageBuilder: (context, anim1, anim2) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: AppColors.kNeutral100.withValues(alpha: 0.1),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Lottie.asset(Assets.lottie.loading, height: 180),
                  ),
                  SizedBox(height: AppSpacing.spaceXs),
                  if (data != null) ...[
                    Text(
                      data,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
