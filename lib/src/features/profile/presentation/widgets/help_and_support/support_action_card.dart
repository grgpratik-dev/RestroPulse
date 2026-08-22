import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class SupportActionCard extends StatelessWidget {
  const SupportActionCard({
    required this.onEmailSupport,
    required this.onReportProblem,
    super.key,
  });

  final VoidCallback onEmailSupport;
  final VoidCallback onReportProblem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.65),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.045),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Still need help?',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.space2xs),
          Text(
            "Contact us and we'll help you resolve the issue.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          OutlinedButton.icon(
            onPressed: onEmailSupport,
            icon: SvgPicture.asset(AppIcons.email_outlined),
            label: const Text('Email Support'),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          FilledButton.icon(
            key: const ValueKey('report-problem-button'),
            onPressed: onReportProblem,
            icon: SvgPicture.asset(AppIcons.bug_report_outlined),
            label: const Text('Report a Problem'),
          ),
        ],
      ),
    );
  }
}
