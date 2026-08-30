import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/bloc/image_picker/image_picker_bloc.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

Future<void> showAppImagePickerBottomSheet(
  BuildContext context, {
  required String title,
  double? maxWidth,
  double? maxHeight,
  int? imageQuality,
}) {
  final imagePickerBloc = context.read<ImagePickerBloc>();

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: AppColors.surface,
    builder: (_) => BlocProvider.value(
      value: imagePickerBloc,
      child: AppImagePickerBottomSheet(
        title: title,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      ),
    ),
  );
}

class AppImagePickerBottomSheet extends StatelessWidget {
  const AppImagePickerBottomSheet({
    required this.title,
    this.maxWidth,
    this.maxHeight,
    this.imageQuality,
    super.key,
  });

  final String title;
  final double? maxWidth;
  final double? maxHeight;
  final int? imageQuality;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImagePickerBloc, ImagePickerState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ImagePickerStatus.success:
          case ImagePickerStatus.cancelled:
            Navigator.of(context).pop();
          case ImagePickerStatus.failure:
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'Could not select the image.',
                  ),
                ),
              );
          case ImagePickerStatus.initial:
          case ImagePickerStatus.picking:
            break;
        }
      },
      builder: (context, state) {
        final isPicking = state.status == ImagePickerStatus.picking;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.spaceLg,
              AppSpacing.spaceXs,
              AppSpacing.spaceLg,
              AppSpacing.spaceLg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceSm),
                ListTile(
                  enabled: !isPicking,
                  leading: SvgPicture.asset(
                    AppIcons.photo_library_outlined,
                    width: 24,
                    height: 24,
                  ),
                  title: const Text('Choose from gallery'),
                  onTap: isPicking
                      ? null
                      : () => context.read<ImagePickerBloc>().add(
                          ImageFromGalleryRequested(
                            maxWidth: maxWidth,
                            maxHeight: maxHeight,
                            imageQuality: imageQuality,
                          ),
                        ),
                ),
                ListTile(
                  enabled: !isPicking,
                  leading: SvgPicture.asset(
                    AppIcons.camera_alt_outlined,
                    width: 24,
                    height: 24,
                  ),
                  title: const Text('Take a photo'),
                  onTap: isPicking
                      ? null
                      : () => context.read<ImagePickerBloc>().add(
                          PhotoCaptureRequested(
                            maxWidth: maxWidth,
                            maxHeight: maxHeight,
                            imageQuality: imageQuality,
                          ),
                        ),
                ),
                if (isPicking) ...[
                  const SizedBox(height: AppSpacing.spaceXs),
                  const LinearProgressIndicator(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
