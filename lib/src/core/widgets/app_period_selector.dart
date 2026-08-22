import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Shared, always-visible period tabs for analytical feature screens.
class AppPeriodSelector<T> extends StatelessWidget {
  const AppPeriodSelector({
    required this.selected,
    required this.options,
    required this.labelOf,
    required this.descriptionOf,
    required this.onChanged,
    this.title = 'Analysis period',
    super.key,
  });

  final T selected;
  final List<T> options;
  final String Function(T value) labelOf;
  final String Function(T value) descriptionOf;
  final ValueChanged<T> onChanged;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<T>(
              key: const ValueKey('app-period-selector'),
              segments: options
                  .map(
                    (option) => ButtonSegment<T>(
                      value: option,
                      label: Text(labelOf(option)),
                    ),
                  )
                  .toList(),
              selected: {selected},
              showSelectedIcon: false,
              onSelectionChanged: (values) => onChanged(values.first),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(vertical: AppSpacing.spaceXs),
                ),
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? AppColors.primary
                      : AppColors.surface,
                ),
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? AppColors.surface
                      : AppColors.neutral700,
                ),
                side: const WidgetStatePropertyAll(
                  BorderSide(color: AppColors.neutral300),
                ),
                textStyle: const WidgetStatePropertyAll(
                  AppTypography.labelLarge,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          Row(
            children: [
              SvgPicture.asset(AppIcons.calendar_today_outlined),
              const SizedBox(width: AppSpacing.space2xs),
              Expanded(
                child: Text(
                  descriptionOf(selected),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
