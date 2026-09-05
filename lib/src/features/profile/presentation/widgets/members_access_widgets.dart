import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class MembersSummaryCard extends StatelessWidget {
  const MembersSummaryCard({
    required this.totalMembers,
    required this.viewerCount,
    required this.restaurantName,
    super.key,
  });

  final int totalMembers;
  final int viewerCount;
  final String restaurantName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$totalMembers members',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.space2xs),
          Text(
            'People with access to $restaurantName',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.surface.withValues(alpha: 0.76),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Wrap(
            spacing: AppSpacing.spaceXs,
            runSpacing: AppSpacing.spaceXs,
            children: [
              const _CountChip(label: '1 Owner'),
              _CountChip(label: '$viewerCount Viewers'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceSm,
        vertical: AppSpacing.spaceXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.surface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class RestaurantJoinCodeCard extends StatelessWidget {
  const RestaurantJoinCodeCard({
    required this.code,
    required this.onCopy,
    required this.onRegenerate,
    required this.onToggle,
    super.key,
  });

  final String? code;
  final VoidCallback? onCopy;
  final VoidCallback? onRegenerate;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = code != null;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.neutral300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.mintChip,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: SvgPicture.asset(
                  AppIcons.vpn_key_outlined,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                  width: 22,
                  height: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Restaurant join code',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space2xs),
                    Text(
                      isEnabled
                          ? 'Active until regenerated'
                          : 'Currently disabled',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          if (isEnabled) ...[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spaceMd,
                vertical: AppSpacing.spaceMd,
              ),
              decoration: BoxDecoration(
                color: AppColors.mintSurface,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: SelectableText(
                code!,
                key: const ValueKey('restaurant-join-code'),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Text(
              'Sharing this code lets someone request Viewer access. Every request still requires owner approval.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.neutral700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            Wrap(
              spacing: AppSpacing.spaceXs,
              runSpacing: AppSpacing.spaceXs,
              children: [
                FilledButton.icon(
                  key: const ValueKey('copy-join-code-button'),
                  onPressed: onCopy,
                  icon: SvgPicture.asset(
                    AppIcons.copy_rounded,
                    width: 18,
                    height: 18,
                  ),
                  label: const Text('Copy code'),
                ),
                OutlinedButton.icon(
                  key: const ValueKey('regenerate-join-code-button'),
                  onPressed: onRegenerate,
                  icon: SvgPicture.asset(
                    AppIcons.refresh_rounded,
                    width: 18,
                    height: 18,
                  ),
                  label: const Text('Regenerate'),
                ),
                TextButton(onPressed: onToggle, child: const Text('Disable')),
              ],
            ),
          ] else
            FilledButton.icon(
              key: const ValueKey('generate-join-code-button'),
              onPressed: onToggle,
              icon: SvgPicture.asset(
                AppIcons.add_rounded,
                width: 20,
                height: 20,
              ),
              label: const Text('Generate join code'),
            ),
        ],
      ),
    );
  }
}

class PendingAccessRequestCard extends StatelessWidget {
  const PendingAccessRequestCard({
    required this.name,
    required this.email,
    required this.onApprove,
    required this.onDecline,
    super.key,
  });

  final String name;
  final String email;
  final VoidCallback? onApprove;
  final VoidCallback? onDecline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.warningSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.warningBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.warning,
                child: SvgPicture.asset(
                  AppIcons.person_outline_rounded,
                  width: 24,
                  height: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space2xs),
                    Text(
                      email,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spaceXs,
                  vertical: AppSpacing.space2xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warningChip,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: const Text(
                  'Viewer',
                  style: TextStyle(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: FilledButton(
                  key: const ValueKey('approve-access-request-button'),
                  onPressed: onApprove,
                  child: const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RestaurantMemberTile extends StatelessWidget {
  const RestaurantMemberTile({
    required this.name,
    required this.email,
    required this.role,
    this.onRemove,
    super.key,
  });

  final String name;
  final String email;
  final String role;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOwner = role == 'Owner';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceMd,
        vertical: AppSpacing.space2xs,
      ),
      leading: CircleAvatar(
        backgroundColor: isOwner ? AppColors.mintChip : AppColors.infoSurface,
        foregroundColor: isOwner ? AppColors.primary : AppColors.info,
        child: SvgPicture.asset(
          isOwner
              ? AppIcons.admin_panel_settings_outlined
              : AppIcons.person_outline,
          width: 24,
          height: 24,
        ),
      ),
      title: Text(
        name,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(email),
      trailing: onRemove == null
          ? _RoleBadge(label: role, isOwner: isOwner)
          : PopupMenuButton<String>(
              tooltip: 'Member actions',
              onSelected: (_) => onRemove!(),
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'remove', child: Text('Remove access')),
              ],
            ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.label, required this.isOwner});

  final String label;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceXs,
        vertical: AppSpacing.space2xs,
      ),
      decoration: BoxDecoration(
        color: isOwner ? AppColors.mintChip : AppColors.infoSurface,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isOwner ? AppColors.primary : AppColors.info,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
