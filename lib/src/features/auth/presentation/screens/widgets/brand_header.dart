import 'package:flutter/widgets.dart';
import 'package:restropulse/gen/assets.gen.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/app_name.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Image.asset(Assets.logo.applogo.path, fit: BoxFit.cover),
          ),
          const SizedBox(height: AppSpacing.space2xs),
          appName(context: context),
        ],
      ),
    );
  }
}
