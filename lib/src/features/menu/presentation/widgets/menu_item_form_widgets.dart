import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/bloc/image_picker/image_picker_bloc.dart';
import '../../../../core/widgets/custom_container.dart';

class MenuPhotoPicker extends StatelessWidget {
  const MenuPhotoPicker({this.initialPath, super.key});

  final String? initialPath;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagePickerBloc, ImagePickerState>(
      builder: (context, state) {
        final path = state.image?.path ?? initialPath;
        return Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: SizedBox.square(
                dimension: 88,
                child: path == null
                    ? const ColoredBox(
                        color: Color(0xFFE4F5EF),
                        child: Icon(
                          Icons.restaurant_menu_rounded,
                          color: AppColors.primary,
                          size: 34,
                        ),
                      )
                    : Image.file(File(path), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: AppSpacing.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Item image',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Optional · JPG or PNG',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceXs),
                  OutlinedButton.icon(
                    onPressed: state.status == ImagePickerStatus.picking
                        ? null
                        : () => context.read<ImagePickerBloc>().add(
                            const ImageFromGalleryRequested(
                              maxWidth: 1200,
                              imageQuality: 85,
                            ),
                          ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    icon: state.status == ImagePickerStatus.picking
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 19,
                          ),
                    label: Text(path == null ? 'Add Photo' : 'Change Photo'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class MenuCostPreview extends StatelessWidget {
  const MenuCostPreview({
    required this.sellingPrice,
    required this.estimatedCost,
    super.key,
  });

  final double sellingPrice;
  final double estimatedCost;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    final foodCost = sellingPrice <= 0
        ? 0.0
        : estimatedCost / sellingPrice * 100;
    final contribution = sellingPrice - estimatedCost;

    return CustomContainer(
      color: const Color(0xFFF0FBF7),
      borderColor: AppColors.primary.withValues(alpha: 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calculate_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.spaceXs),
              Text(
                'Live cost preview',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Row(
            children: [
              Expanded(
                child: _PreviewMetric(
                  label: 'Selling price',
                  value: 'Rs ${currency.format(sellingPrice)}',
                ),
              ),
              Expanded(
                child: _PreviewMetric(
                  label: 'Estimated cost',
                  value: 'Rs ${currency.format(estimatedCost)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Row(
            children: [
              Expanded(
                child: _PreviewMetric(
                  label: 'Food cost',
                  value: '${foodCost.toStringAsFixed(1)}%',
                ),
              ),
              Expanded(
                child: _PreviewMetric(
                  label: 'Contribution',
                  value: 'Rs ${currency.format(contribution)}',
                  emphasize: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MenuCostWarning extends StatelessWidget {
  const MenuCostWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceSm),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: const Color(0xFFFDBA74)),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFF9A3412)),
          SizedBox(width: AppSpacing.spaceXs),
          Expanded(
            child: Text(
              'Estimated cost is higher than the selling price.',
              style: TextStyle(
                color: Color(0xFF9A3412),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewMetric extends StatelessWidget {
  const _PreviewMetric({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: emphasize ? AppColors.primary : null,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
