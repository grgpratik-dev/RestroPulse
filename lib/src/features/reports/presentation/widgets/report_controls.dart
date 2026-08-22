import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_period_selector.dart';
import '../../domain/models/report_data.dart';

class ReportPeriodSelector extends StatelessWidget {
  const ReportPeriodSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final ReportPeriod selected;
  final ValueChanged<ReportPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppPeriodSelector<ReportPeriod>(
      selected: selected,
      options: ReportPeriod.values,
      labelOf: (period) => period.label,
      descriptionOf: (period) => period.dateLabel,
      title: 'Report period',
      onChanged: onChanged,
    );
  }
}

class ReportExportOption extends StatelessWidget {
  const ReportExportOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.mintSurface,
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        onTap: onTap,
        leading: SvgPicture.asset(
          icon,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: SvgPicture.asset(AppIcons.chevron_right_rounded),
      ),
    );
  }
}
