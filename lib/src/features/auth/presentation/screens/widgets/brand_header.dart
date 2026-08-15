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
            appName(context: context),
          ],
        ),
      ),
    );
  }
}
