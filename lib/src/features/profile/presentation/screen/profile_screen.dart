import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/src/app/router/app_route.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/app_confirmation_dialog.dart';

import '../widgets/logout_confirmation_dialog.dart';
import '../widgets/logout_tile.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/settings_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spaceMd,
            AppSpacing.spaceSm,
            AppSpacing.spaceMd,
            AppSpacing.space2xl,
          ),
          children: [
            ProfileHeaderCard(
              onEdit: () => context.pushNamed(AppRoute.editRestaurant.name),
            ),
            const SizedBox(height: AppSpacing.spaceXl),
            SettingsSection(
              title: 'Restaurant',
              children: [
                SettingsTile(
                  icon: Icons.group_outlined,
                  title: 'Members & Access',
                  subtitle: '2 members · 1 pending request',
                  onTap: () => context.pushNamed(AppRoute.membersAccess.name),
                ),
                SettingsTile(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Currency',
                  subtitle: 'NPR (Rs)',
                  onTap: () => _showCurrencySheet(context),
                ),
                SettingsTile(
                  icon: Icons.restaurant_menu_rounded,
                  title: 'Menu Categories',
                  subtitle: 'Manage food and drink categories',
                  onTap: () => context.pushNamed(AppRoute.menuCategories.name),
                ),
                SettingsTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'Expense Categories',
                  subtitle: 'Manage expense classifications',
                  onTap: () =>
                      context.pushNamed(AppRoute.expenseCategories.name),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spaceXl),
            SettingsSection(
              title: 'Account',
              children: [
                SettingsTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Personal Information',
                  subtitle: 'Name and account details',
                  onTap: () =>
                      context.pushNamed(AppRoute.personalInformation.name),
                ),
                SettingsTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change Password',
                  onTap: () => context.pushNamed(AppRoute.changePassword.name),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spaceXl),
            SettingsSection(
              title: 'Preferences',
              children: [
                SettingsTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  subtitle: 'Reports, reminders and alerts',
                  onTap: () => _showPlaceholder(context, 'Notifications'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spaceXl),
            SettingsSection(
              title: 'Support',
              children: [
                SettingsTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  onTap: () => context.pushNamed(AppRoute.helpSupport.name),
                ),
                SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () => _showPlaceholder(context, 'Terms of service'),
                ),
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => _showPlaceholder(context, 'Privacy policy'),
                ),
                SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About RestroPulse',
                  subtitle: 'Version 1.0.0',
                  onTap: () => _showAboutDialog(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spaceXl),
            LogoutTile(onTap: () => _confirmLogout(context)),
          ],
        ),
      ),
    );
  }

  void _showPlaceholder(BuildContext context, String feature) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$feature settings are coming soon.')),
      );
  }

  Future<void> _showCurrencySheet(BuildContext context) {
    final theme = Theme.of(context);

    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: theme.colorScheme.surface,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.spaceLg,
              AppSpacing.spaceXs,
              AppSpacing.spaceLg,
              AppSpacing.spaceLg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Select currency',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                Material(
                  color: AppColors.splashAccent.withValues(alpha: 0.42),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: ListTile(
                    onTap: () => Navigator.of(sheetContext).pop(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spaceMd,
                      vertical: AppSpacing.space2xs,
                    ),
                    leading: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        'Rs',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    title: const Text('NPR (Rs)'),
                    subtitle: const Text('Nepalese Rupee'),
                    trailing: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAboutDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => const AppConfirmationDialog(
        title: 'RestroPulse',
        message:
            'A simple restaurant performance and analytics companion.\n\nVersion 1.0.0',
        confirmLabel: 'Close',
        icon: Icons.storefront_rounded,
        showCancelButton: false,
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return LogoutConfirmationDialog(
          onCancel: () => Navigator.of(dialogContext).pop(false),
          onConfirm: () => Navigator.of(dialogContext).pop(true),
        );
      },
    );

    if (confirmed != true || !context.mounted) return;
    if (onLogout != null) {
      onLogout!();
    } else {
      context.goNamed(AppRoute.login.name);
    }
  }
}
