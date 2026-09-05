import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class RestaurantLogoSelector extends StatelessWidget {
  const RestaurantLogoSelector({
    required this.onTap,
    this.imageBytes,
    super.key,
  });

  final VoidCallback? onTap;
  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.spaceSm),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutral300),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.mintChip,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                clipBehavior: Clip.antiAlias,
                child: imageBytes != null
                    ? Image.memory(
                        imageBytes!,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const Icon(Icons.broken_image_outlined),
                      )
                    : SvgPicture.asset(
                        AppIcons.add_photo_alternate_outlined,
                        width: 28,
                        height: 28,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary,
                          BlendMode.srcIn,
                        ),
                      ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      imageBytes == null
                          ? 'Add restaurant logo'
                          : 'Change restaurant logo',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space2xs),
                    Text(
                      'Optional · You can add this later',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
