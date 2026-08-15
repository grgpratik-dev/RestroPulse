part of '../login/login_screen.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: 'RestroPulse',
      header: true,
      child: ExcludeSemantics(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              padding: const EdgeInsets.all(AppSpacing.spaceXs),
              child: Image.asset(Assets.logo.applogo.path, fit: BoxFit.contain),
            ),
            const SizedBox(width: AppSpacing.spaceSm),
            Text.rich(
              TextSpan(
                text: 'Restro',
                children: const [
                  TextSpan(
                    text: 'Pulse',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontFamily: AppTypography.plusJakartaSansFontFamily,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
