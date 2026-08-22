import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

enum SalesEntryType { singleOrder, batchEntry }

Future<SalesEntryType?> showSalesEntryTypeSheet(BuildContext context) {
  return showModalBottomSheet<SalesEntryType>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const _SalesEntryTypeSheet(),
  );
}

class _SalesEntryTypeSheet extends StatelessWidget {
  const _SalesEntryTypeSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.spaceLg,
          0,
          AppSpacing.spaceLg,
          AppSpacing.spaceLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Record Sales',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Choose how you want to enter today’s sales.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            _EntryOption(
              icon: AppIcons.receipt_long_outlined,
              title: 'Single Order',
              subtitle: 'Record one customer order with its items and channel.',
              badge: 'Recommended',
              emphasized: true,
              onTap: () => Navigator.pop(context, SalesEntryType.singleOrder),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            _EntryOption(
              icon: AppIcons.playlist_add_rounded,
              title: 'Batch Entry',
              subtitle: 'Record several orders quickly in one entry session.',
              onTap: () => Navigator.pop(context, SalesEntryType.batchEntry),
            ),
          ],
        ),
      ),
    );
  }
}

class _EntryOption extends StatelessWidget {
  const _EntryOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
    this.emphasized = false,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badge;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: emphasized ? AppColors.mintSurface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: emphasized
              ? AppColors.primary.withValues(alpha: 0.35)
              : Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spaceMd),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: emphasized ? AppColors.primary : AppColors.mintSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SvgPicture.asset(
                  icon,
                  width: 26,
                  height: 26,
                  colorFilter: ColorFilter.mode(
                    emphasized ? Colors.white : AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: AppSpacing.spaceXs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.mintChip,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              badge!,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.spaceXs),
              SvgPicture.asset(
                AppIcons.chevron_right_rounded,
                width: 20,
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
