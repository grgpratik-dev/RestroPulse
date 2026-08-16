import 'package:flutter/material.dart';
import 'package:restropulse/gen/assets.gen.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/app_name.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/widgets/restaurant_access_option_card.dart';

class RestaurantAccessScreen extends StatelessWidget {
  const RestaurantAccessScreen({
    this.onCreateRestaurant,
    this.onJoinRestaurant,
    super.key,
  });

  final VoidCallback? onCreateRestaurant;
  final VoidCallback? onJoinRestaurant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 76,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.authBackground,
        surfaceTintColor: Colors.transparent,
        title: const _BrandLockup(),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.spaceLg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How will you use RestroPulse?',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceXs),
                  Text(
                    'Create a restaurant to manage it, or join one you have been invited to view.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutral700,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceLg),
                  RestaurantAccessOptionCard(
                    key: const ValueKey('create-restaurant-option'),
                    icon: Icons.add_business_rounded,
                    title: 'Create your restaurant',
                    roleLabel: 'Owner access',
                    description:
                        'Set up the restaurant and manage sales, expenses, menu items, members, and reports.',
                    permissionSummary:
                        'Full access to view and manage restaurant data',
                    actionLabel: 'Start restaurant setup',
                    onTap: onCreateRestaurant ?? () {},
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),
                  RestaurantAccessOptionCard(
                    key: const ValueKey('join-restaurant-option'),
                    icon: Icons.group_add_outlined,
                    title: 'Join a restaurant',
                    roleLabel: 'Viewer access',
                    description:
                        'Join with an invitation from the owner and stay informed about restaurant performance.',
                    permissionSummary:
                        'View only — you cannot add, edit, or delete data',
                    actionLabel: 'Enter invitation',
                    isViewer: true,
                    onTap: onJoinRestaurant ?? () {},
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),
                  Center(
                    child: Text(
                      'An owner can manage member access later.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
          mainAxisAlignment: MainAxisAlignment.center,
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
