import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/bloc/image_picker/image_picker_bloc.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class ExpenseReceiptPicker extends StatelessWidget {
  const ExpenseReceiptPicker({this.initialPath, super.key});

  final String? initialPath;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagePickerBloc, ImagePickerState>(
      builder: (context, state) {
        final path = state.image?.path ?? initialPath;
        return Container(
          padding: const EdgeInsets.all(AppSpacing.spaceSm),
          decoration: BoxDecoration(
            color: AppColors.expenseSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.expenseBorder),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox.square(
                  dimension: 62,
                  child: path == null
                      ? ColoredBox(
                          color: Colors.white,
                          child: Center(
                            child: SvgPicture.asset(
                              AppIcons.receipt_long_outlined,
                              width: 30,
                              height: 30,
                              colorFilter: const ColorFilter.mode(
                                AppColors.expenseForeground,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        )
                      : Image.file(File(path), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Receipt (optional)',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      path == null
                          ? 'Add a photo for reference'
                          : 'Receipt attached',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: state.status == ImagePickerStatus.picking
                    ? null
                    : () => context.read<ImagePickerBloc>().add(
                        const ImageFromGalleryRequested(
                          maxWidth: 1400,
                          imageQuality: 85,
                        ),
                      ),
                icon: SvgPicture.asset(
                  AppIcons.attach_file_rounded,
                  width: 18,
                  height: 18,
                ),
                label: Text(path == null ? 'Attach' : 'Change'),
              ),
            ],
          ),
        );
      },
    );
  }
}
