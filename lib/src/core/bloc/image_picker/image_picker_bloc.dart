import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/media/image_picker_service.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

/// Coordinates image-picker state for one screen or flow.
///
/// Register this BLoC as a factory and provide it near the screen that uses it.
/// The droppable transformer prevents a double tap from opening two pickers.
final class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc(this._imagePickerService) : super(const ImagePickerState()) {
    on<ImagePickerRequested>(_onPickerRequested, transformer: droppable());
    on<ImagePickerCleared>(_onCleared);
  }

  final ImagePickerService _imagePickerService;

  Future<void> _onPickerRequested(
    ImagePickerRequested event,
    Emitter<ImagePickerState> emit,
  ) async {
    emit(state.copyWith(status: ImagePickerStatus.picking, clearError: true));

    try {
      final images = switch (event) {
        ImageFromGalleryRequested() => await _pickFromGallery(event),
        PhotoCaptureRequested() => await _takePhoto(event),
        MultipleImagesRequested() => await _pickMultiple(event),
        LostImagesRecoveryRequested() => await _recoverLostImages(),
      };

      emit(
        state.copyWith(
          status: images.isEmpty
              ? ImagePickerStatus.cancelled
              : ImagePickerStatus.success,
          images: images,
          clearError: true,
        ),
      );
    } on PlatformException catch (error) {
      emit(
        state.copyWith(
          status: ImagePickerStatus.failure,
          errorMessage: error.message ?? 'Unable to access images.',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ImagePickerStatus.failure,
          errorMessage: 'Unable to pick an image: $error',
        ),
      );
    }
  }

  Future<List<XFile>> _pickFromGallery(ImageFromGalleryRequested event) async {
    final image = await _imagePickerService.pickFromGallery(
      maxWidth: event.maxWidth,
      maxHeight: event.maxHeight,
      imageQuality: event.imageQuality,
    );
    return <XFile>[?image];
  }

  Future<List<XFile>> _takePhoto(PhotoCaptureRequested event) async {
    final image = await _imagePickerService.takePhoto(
      maxWidth: event.maxWidth,
      maxHeight: event.maxHeight,
      imageQuality: event.imageQuality,
      preferredCameraDevice: event.preferredCameraDevice,
    );
    return <XFile>[?image];
  }

  Future<List<XFile>> _pickMultiple(MultipleImagesRequested event) {
    return _imagePickerService.pickMultipleFromGallery(
      maxWidth: event.maxWidth,
      maxHeight: event.maxHeight,
      imageQuality: event.imageQuality,
      limit: event.limit,
    );
  }

  Future<List<XFile>> _recoverLostImages() async {
    final response = await _imagePickerService.retrieveLostData();
    if (response.exception case final exception?) {
      throw exception;
    }
    return response.files ?? const [];
  }

  void _onCleared(ImagePickerCleared event, Emitter<ImagePickerState> emit) {
    emit(const ImagePickerState());
  }
}
