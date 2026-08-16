import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_info_row.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../domain/models/wastage.dart';

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
          icon: const Icon(Icons.arrow_back_rounded),
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
                    child: Icon(
                      Icons.delete_sweep_outlined,
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
                    const Divider(height: 24),
                    AppInfoRow(label: 'Quantity', value: _entry.quantityLabel!),
                  ],
                  const Divider(height: 24),
                  AppInfoRow(
                    label: 'Date',
                    value: DateFormat('MMM d, yyyy').format(_entry.date),
                  ),
                  const Divider(height: 24),
                  AppInfoRow(
                    label: 'Time',
                    value: DateFormat.jm().format(_entry.date),
                  ),
                  if (_entry.notes?.isNotEmpty == true) ...[
                    const Divider(height: 24),
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
              icon: const Icon(Icons.delete_outline_rounded),
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
      builder: (context) => AlertDialog(
        title: const Text('Delete wastage entry?'),
        content: const Text(
          "This entry will be removed from your restaurant's wastage analytics.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    Navigator.pop(context, const WastageDetailsResult.deleted());
  }
}
