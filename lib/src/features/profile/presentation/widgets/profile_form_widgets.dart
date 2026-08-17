import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

class ProfileFormSection extends StatelessWidget {
  const ProfileFormSection({
    required this.title,
    required this.children,
    this.description,
    super.key,
  });

  final String title;
  final String? description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: AppSpacing.space2xs),
          Text(
            description!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.neutral600,
              height: 1.4,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.spaceMd),
        ...children,
      ],
    );
  }
}

class ProfileImageEditor extends StatelessWidget {
  const ProfileImageEditor({
    required this.label,
    required this.onTap,
    this.isRestaurant = false,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final bool isRestaurant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.mintSurface,
                  shape: isRestaurant ? BoxShape.rectangle : BoxShape.circle,
                  borderRadius: isRestaurant
                      ? BorderRadius.circular(AppRadius.xl)
                      : null,
                  border: Border.all(color: AppColors.mintBright),
                ),
                child: AppIcon(
                  isRestaurant
                      ? AppIcons.storefront_rounded
                      : AppIcons.person_rounded,
                  color: AppColors.primary,
                  size: 44,
                ),
              ),
              Positioned(
                right: -4,
                bottom: -4,
                child: Material(
                  color: AppColors.primary,
                  shape: const CircleBorder(),
                  child: InkWell(
                    key: ValueKey(
                      isRestaurant
                          ? 'edit-restaurant-logo-button'
                          : 'edit-profile-photo-button',
                    ),
                    onTap: onTap,
                    customBorder: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(AppSpacing.spaceXs),
                      child: AppIcon(
                        AppIcons.camera_alt_outlined,
                        color: AppColors.surface,
                        size: 19,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showProfileImageOptions(
  BuildContext context, {
  required String title,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: AppColors.surface,
    builder: (sheetContext) => SafeArea(
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
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            ListTile(
              leading: const AppIcon(AppIcons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.of(sheetContext).pop(),
            ),
            ListTile(
              leading: const AppIcon(AppIcons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.of(sheetContext).pop(),
            ),
          ],
        ),
      ),
    ),
  );
}
