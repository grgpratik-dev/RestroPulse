import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

enum SalesEntryType { singleOrder, batchEntry }

Future<SalesEntryType?> showSalesEntryTypeSheet(BuildContext context) {
  return showModalBottomSheet<SalesEntryType>(
    context: context,
    showDragHandle: true,
    builder: (context) => const _SalesEntryTypeSheet(),
  );
}

class _SalesEntryTypeSheet extends StatelessWidget {
  const _SalesEntryTypeSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
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
              icon: Icons.receipt_long_outlined,
              title: 'Single Order',
              subtitle: 'Record one customer order with its items and channel.',
              badge: 'Recommended',
              emphasized: true,
              onTap: () => Navigator.pop(context, SalesEntryType.singleOrder),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            _EntryOption(
              icon: Icons.playlist_add_rounded,
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

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badge;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: emphasized ? const Color(0xFFF0FBF7) : Colors.white,
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
                decoration: BoxDecoration(
                  color: emphasized
                      ? AppColors.primary
                      : const Color(0xFFE4F5EF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: emphasized ? Colors.white : AppColors.primary,
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
                              color: const Color(0xFFDDF7EC),
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
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
