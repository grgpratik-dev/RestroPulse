import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/wastage.dart';

enum WastageHistorySort {
  newest('Newest first'),
  oldest('Oldest first'),
  highestLoss('Highest loss'),
  lowestLoss('Lowest loss');

  const WastageHistorySort(this.label);

  final String label;
}

const wastageFilterReasons = [
  WastageReason.overproduction,
  WastageReason.expired,
  WastageReason.preparationMistake,
  WastageReason.customerReturn,
  WastageReason.damaged,
  WastageReason.other,
];

class WastageHistoryFilterSelection {
  const WastageHistoryFilterSelection({
    this.reason,
    this.sort = WastageHistorySort.newest,
  });

  final WastageReason? reason;
  final WastageHistorySort sort;

  bool get isActive => reason != null || sort != WastageHistorySort.newest;
}

Future<WastageHistoryFilterSelection?> showWastageHistoryFilterSheet({
  required BuildContext context,
  required WastageHistoryFilterSelection initial,
}) {
  return showModalBottomSheet<WastageHistoryFilterSelection>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _WastageHistoryFilterSheet(initial: initial),
  );
}

class _WastageHistoryFilterSheet extends StatefulWidget {
  const _WastageHistoryFilterSheet({required this.initial});

  final WastageHistoryFilterSelection initial;

  @override
  State<_WastageHistoryFilterSheet> createState() =>
      _WastageHistoryFilterSheetState();
}

class _WastageHistoryFilterSheetState
    extends State<_WastageHistoryFilterSheet> {
  late WastageReason? _reason = widget.initial.reason;
  late WastageHistorySort _sort = widget.initial.sort;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Filter Wastage',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    _reason = null;
                    _sort = WastageHistorySort.newest;
                  }),
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            const Text('Reason', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.spaceXs),
            DropdownButtonFormField<WastageReason?>(
              isExpanded: true,
              initialValue: _reason,
              decoration: const InputDecoration(hintText: 'All reasons'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All reasons')),
                ...wastageFilterReasons.map(
                  (reason) => DropdownMenuItem(
                    value: reason,
                    child: Text(reason.label),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _reason = value),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            const Text('Sort', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.spaceXs),
            DropdownButtonFormField<WastageHistorySort>(
              isExpanded: true,
              initialValue: _sort,
              items: WastageHistorySort.values
                  .map(
                    (sort) =>
                        DropdownMenuItem(value: sort, child: Text(sort.label)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _sort = value);
              },
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(
                  context,
                  WastageHistoryFilterSelection(reason: _reason, sort: _sort),
                ),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
