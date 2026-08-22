import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/gen/assets.gen.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/app_name.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class RestaurantAccessAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const RestaurantAccessAppBar({this.showBackButton = false, super.key});

  final bool showBackButton;

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).maybePop(),
              icon: SvgPicture.asset(
                AppIcons.arrow_back_rounded,
                width: 24,
                height: 24,
              ),
            )
          : null,
      toolbarHeight: preferredSize.height,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.authBackground,
      surfaceTintColor: Colors.transparent,
      title: const _BrandLockup(),
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup();

  @override
  Widget build(BuildContext context) {
    return Semantics(
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
    );
  }
}
