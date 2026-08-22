import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/wastage.dart';
import '../widgets/wastage_cards.dart';
import '../widgets/wastage_states.dart';
import 'wastage_details_screen.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

enum WastageViewState { loaded, noPeriodData, empty, loading, error }

class WastageScreen extends StatefulWidget {
  const WastageScreen({
    this.viewState = WastageViewState.loaded,
    this.initialEntries,
    this.onTryAgain,
    super.key,
  });

  final WastageViewState viewState;
  final List<WastageEntry>? initialEntries;
  final VoidCallback? onTryAgain;

  @override
  State<WastageScreen> createState() => _WastageScreenState();
}

class _WastageScreenState extends State<WastageScreen> {
  late final List<WastageEntry> _entries = [
    ...(widget.initialEntries ?? WastageMockData.entries),
  ];
  static const _period = WastagePeriod.month;
  double _lossAdjustment = 0;
  int _entryAdjustment = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wastage')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Text(
              'Track food loss and understand where it happens.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'This Month · August 2026',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.viewState == WastageViewState.loading) {
      return const WastageLoadingSkeleton();
    }
    if (widget.viewState == WastageViewState.error) {
      return WastageStateMessage(
        icon: AppIcons.cloud_off_rounded,
        title: "Couldn't load wastage data",
        message: 'Check your connection and try again.',
        actionLabel: 'Try Again',
        onAction: widget.onTryAgain ?? () {},
      );
    }
    if (widget.viewState == WastageViewState.empty || _entries.isEmpty) {
      return WastageStateMessage(
        title: 'No wastage recorded',
        message:
            'Record food loss to understand where your restaurant is losing value.',
        actionLabel: 'Record Wastage',
        onAction: _recordWastage,
      );
    }
    if (widget.viewState == WastageViewState.noPeriodData) {
      return WastageStateMessage(
        icon: AppIcons.event_available_outlined,
        title: 'No wastage recorded in this period',
        message: "That's a good sign, or try another time range.",
        actionLabel: 'Record Wastage',
        onAction: _recordWastage,
      );
    }

    final base = WastageMockData.snapshot(_period);
    final snapshot = WastageSnapshot(
      total: base.total + _lossAdjustment,
      change: base.change,
      entries: base.entries + _entryAdjustment,
      comparisonLabel: base.comparisonLabel,
      trend: base.trend,
    );
    return Column(
      children: [
        WastageSummaryCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.spaceMd),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _recordWastage,
            icon: SvgPicture.asset(AppIcons.add_rounded),
            label: const Text('Record Wastage'),
          ),
        ),
        const SizedBox(height: AppSpacing.spaceLg),
        WastageTrendCard(period: _period, points: snapshot.trend),
        const SizedBox(height: AppSpacing.spaceLg),
        const WastageReasonsSection(reasons: WastageMockData.reasons),
        const SizedBox(height: AppSpacing.spaceLg),
        const MostWastedItemsSection(items: WastageMockData.topItems),
        const SizedBox(height: AppSpacing.spaceLg),
        RecentWastageSection(entries: _entries, onTap: _openEntry),
      ],
    );
  }

  Future<void> _recordWastage() async {
    final entry = await context.pushNamed<WastageEntry>(
      AppRoute.recordWastage.name,
    );
    if (!mounted || entry == null) return;
    setState(() {
      _entries.insert(0, entry);
      _lossAdjustment += entry.estimatedLoss;
      _entryAdjustment += 1;
    });
  }

  Future<void> _openEntry(WastageEntry entry) async {
    final result = await context.pushNamed<WastageDetailsResult>(
      AppRoute.wastageDetails.name,
      extra: entry,
    );
    if (!mounted || result == null) return;
    setState(() {
      final index = _entries.indexWhere((item) => item.id == entry.id);
      if (result.deleted && index >= 0) {
        _lossAdjustment -= _entries[index].estimatedLoss;
        _entryAdjustment -= 1;
        _entries.removeAt(index);
      } else if (index >= 0 && result.entry != null) {
        _lossAdjustment +=
            result.entry!.estimatedLoss - _entries[index].estimatedLoss;
        _entries[index] = result.entry!;
      }
    });
  }
}
