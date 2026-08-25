import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/widgets/app_period_selector.dart';
import '../../domain/models/wastage.dart';
import '../widgets/wastage_history_filter_sheet.dart';
import '../widgets/wastage_history_widgets.dart';
import 'wastage_details_screen.dart';

enum WastageHistoryPeriod {
  week('1W'),
  month('1M'),
  quarter('3M'),
  sixMonths('6M'),
  year('1Y');

  const WastageHistoryPeriod(this.label);

  final String label;
}

class WastageHistoryScreen extends StatefulWidget {
  const WastageHistoryScreen({this.initialEntries, super.key});

  final List<WastageEntry>? initialEntries;

  @override
  State<WastageHistoryScreen> createState() => _WastageHistoryScreenState();
}

class _WastageHistoryScreenState extends State<WastageHistoryScreen> {
  static final DateTime _latestRecordedDate = DateTime(2026, 8, 16);

  late final List<WastageEntry> _entries = [
    ...(widget.initialEntries ?? WastageMockData.entries),
  ];
  WastageHistoryPeriod _period = WastageHistoryPeriod.month;
  WastageHistoryFilterSelection _filters =
      const WastageHistoryFilterSelection();

  DateTimeRange get _range => _rangeFor(_period);

  List<WastageEntry> get _visibleEntries {
    final inclusiveEnd = _range.end.add(const Duration(days: 1));
    final values = _entries.where((entry) {
      final inRange =
          !entry.date.isBefore(_range.start) &&
          entry.date.isBefore(inclusiveEnd);
      final reasonMatches =
          _filters.reason == null || entry.reason == _filters.reason;
      return inRange && reasonMatches;
    }).toList();

    switch (_filters.sort) {
      case WastageHistorySort.newest:
        values.sort((a, b) => b.date.compareTo(a.date));
      case WastageHistorySort.oldest:
        values.sort((a, b) => a.date.compareTo(b.date));
      case WastageHistorySort.highestLoss:
        values.sort((a, b) => b.estimatedLoss.compareTo(a.estimatedLoss));
      case WastageHistorySort.lowestLoss:
        values.sort((a, b) => a.estimatedLoss.compareTo(b.estimatedLoss));
    }
    return values;
  }

  List<DateTime> get _groupDates {
    final dates = _visibleEntries
        .map(
          (entry) =>
              DateTime(entry.date.year, entry.date.month, entry.date.day),
        )
        .toSet()
        .toList();
    final oldestFirst = _filters.sort == WastageHistorySort.oldest;
    dates.sort((a, b) => oldestFirst ? a.compareTo(b) : b.compareTo(a));
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    final entries = _visibleEntries;
    final totalLoss = entries.fold<double>(
      0,
      (sum, entry) => sum + entry.estimatedLoss,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wastage History'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spaceMd,
            AppSpacing.spaceXs,
            AppSpacing.spaceMd,
            AppSpacing.spaceXl,
          ),
          children: [
            AppPeriodSelector<WastageHistoryPeriod>(
              selected: _period,
              options: WastageHistoryPeriod.values,
              labelOf: (period) => period.label,
              descriptionOf: (period) => _formatRange(_rangeFor(period)),
              title: 'Wastage history period',
              onChanged: (period) => setState(() => _period = period),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            WastageHistorySummary(
              rangeLabel: _formatRange(_range),
              totalLoss: totalLoss,
              entries: entries.length,
              topReason: _topReason(entries),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: _showFilters,
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: _filters.isActive
                      ? AppColors.warningMuted
                      : null,
                ),
                icon: SvgPicture.asset(
                  _filters.isActive
                      ? AppIcons.filter_alt_rounded
                      : AppIcons.filter_alt_outlined,
                  width: 18,
                  height: 18,
                ),
                label: const Text('Filter'),
              ),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            if (entries.isEmpty)
              WastageHistoryEmptyState(onChangeFilters: _showFilters)
            else
              for (var index = 0; index < _groupDates.length; index++) ...[
                WastageHistoryGroup(
                  date: _groupDates[index],
                  entries: _entriesForDate(entries, _groupDates[index]),
                  onEntryTap: _openEntry,
                ),
                if (index != _groupDates.length - 1)
                  const SizedBox(height: AppSpacing.spaceMd),
              ],
          ],
        ),
      ),
    );
  }

  List<WastageEntry> _entriesForDate(List<WastageEntry> values, DateTime date) {
    final results = values.where((entry) {
      return entry.date.year == date.year &&
          entry.date.month == date.month &&
          entry.date.day == date.day;
    }).toList();
    switch (_filters.sort) {
      case WastageHistorySort.newest:
        results.sort((a, b) => b.date.compareTo(a.date));
      case WastageHistorySort.oldest:
        results.sort((a, b) => a.date.compareTo(b.date));
      case WastageHistorySort.highestLoss:
        results.sort((a, b) => b.estimatedLoss.compareTo(a.estimatedLoss));
      case WastageHistorySort.lowestLoss:
        results.sort((a, b) => a.estimatedLoss.compareTo(b.estimatedLoss));
    }
    return results;
  }

  WastageReason? _topReason(List<WastageEntry> values) {
    if (values.isEmpty) return null;
    final totals = <WastageReason, double>{};
    for (final entry in values) {
      totals.update(
        entry.reason,
        (value) => value + entry.estimatedLoss,
        ifAbsent: () => entry.estimatedLoss,
      );
    }
    return totals.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  DateTimeRange _rangeFor(WastageHistoryPeriod period) {
    final end = _latestRecordedDate;
    final start = switch (period) {
      WastageHistoryPeriod.week => end.subtract(const Duration(days: 6)),
      WastageHistoryPeriod.month => DateTime(end.year, end.month),
      WastageHistoryPeriod.quarter => DateTime(end.year, end.month - 2),
      WastageHistoryPeriod.sixMonths => DateTime(end.year, end.month - 5),
      WastageHistoryPeriod.year => DateTime(end.year - 1, end.month + 1),
    };
    return DateTimeRange(start: start, end: end);
  }

  String _formatRange(DateTimeRange range) {
    if (range.start.year == range.end.year) {
      return '${DateFormat('MMM d').format(range.start)} – '
          '${DateFormat('MMM d, y').format(range.end)}';
    }
    return '${DateFormat('MMM d, y').format(range.start)} – '
        '${DateFormat('MMM d, y').format(range.end)}';
  }

  Future<void> _showFilters() async {
    final selection = await showWastageHistoryFilterSheet(
      context: context,
      initial: _filters,
    );
    if (!mounted || selection == null) return;
    setState(() => _filters = selection);
  }

  Future<void> _openEntry(WastageEntry entry) async {
    final result = await context.pushNamed<WastageDetailsResult>(
      AppRoute.wastageDetails.name,
      extra: entry,
    );
    if (!mounted || result == null) return;
    setState(() {
      final index = _entries.indexWhere((value) => value.id == entry.id);
      if (result.deleted) {
        if (index >= 0) _entries.removeAt(index);
      } else if (index >= 0 && result.entry != null) {
        _entries[index] = result.entry!;
      }
    });
  }
}
