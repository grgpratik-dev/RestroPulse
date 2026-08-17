import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_info_row.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../core/widgets/app_divider.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../domain/models/wastage.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

class WastageDetailsResult {
  const WastageDetailsResult.updated(this.entry) : deleted = false;
  const WastageDetailsResult.deleted() : entry = null, deleted = true;
  final WastageEntry? entry;
  final bool deleted;
}

class WastageDetailsScreen extends StatefulWidget {
  const WastageDetailsScreen({required this.entry, super.key});
  final WastageEntry entry;

  @override
  State<WastageDetailsScreen> createState() => _WastageDetailsScreenState();
}

class _WastageDetailsScreenState extends State<WastageDetailsScreen> {
  late WastageEntry _entry = widget.entry;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () =>
              Navigator.pop(context, WastageDetailsResult.updated(_entry)),
          icon: const AppIcon(AppIcons.arrow_back_rounded),
        ),
        title: const Text('Wastage Details'),
        actions: [
          TextButton(onPressed: _edit, child: const Text('Edit')),
          const SizedBox(width: AppSpacing.spaceXs),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.warningMuted,
                    child: AppIcon(
                      AppIcons.delete_sweep_outlined,
                      color: AppColors.warning,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),
                  Text(
                    _entry.itemName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs ${currency.format(_entry.estimatedLoss)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text('Estimated loss'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            CustomContainer(
              child: Column(
                children: [
                  AppInfoRow(label: 'Reason', value: _entry.reason.label),
                  if (_entry.quantityLabel != null) ...[
                    const AppDivider(),
                    AppInfoRow(label: 'Quantity', value: _entry.quantityLabel!),
                  ],
                  const AppDivider(),
                  AppInfoRow(
                    label: 'Date',
                    value: DateFormat('MMM d, yyyy').format(_entry.date),
                  ),
                  const AppDivider(),
                  AppInfoRow(
                    label: 'Time',
                    value: DateFormat.jm().format(_entry.date),
                  ),
                  if (_entry.notes?.isNotEmpty == true) ...[
                    const AppDivider(),
                    AppInfoRow(label: 'Notes', value: _entry.notes!),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spaceXl),
            OutlinedButton.icon(
              onPressed: _delete,
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              icon: const AppIcon(AppIcons.delete_outline_rounded),
              label: const Text('Delete Entry'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _edit() async {
    final entry = await context.pushNamed<WastageEntry>(
      AppRoute.recordWastage.name,
      extra: _entry,
    );
    if (!mounted || entry == null) return;
    setState(() => _entry = entry);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const AppConfirmationDialog(
        title: 'Delete wastage entry?',
        message:
            "This entry will be removed from your restaurant's wastage analytics.",
        confirmLabel: 'Delete',
        icon: AppIcons.delete_outline_rounded,
        isDestructive: true,
      ),
    );
    if (!mounted || confirmed != true) return;
    Navigator.pop(context, const WastageDetailsResult.deleted());
  }
}
