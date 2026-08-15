part of 'image_picker_bloc.dart';

sealed class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();

  @override
  List<Object?> get props => [];
}

sealed class ImagePickerRequested extends ImagePickerEvent {
  const ImagePickerRequested();
}

final class ImageFromGalleryRequested extends ImagePickerRequested {
  const ImageFromGalleryRequested({
    this.maxWidth,
    this.maxHeight,
    this.imageQuality,
  });

  final double? maxWidth;
  final double? maxHeight;
  final int? imageQuality;

  @override
  List<Object?> get props => [maxWidth, maxHeight, imageQuality];
}

final class PhotoCaptureRequested extends ImagePickerRequested {
  const PhotoCaptureRequested({
    this.maxWidth,
    this.maxHeight,
    this.imageQuality,
    this.preferredCameraDevice = CameraDevice.rear,
  });

  final double? maxWidth;
  final double? maxHeight;
  final int? imageQuality;
  final CameraDevice preferredCameraDevice;

  @override
  List<Object?> get props => [
    maxWidth,
    maxHeight,
    imageQuality,
    preferredCameraDevice,
  ];
}

final class MultipleImagesRequested extends ImagePickerRequested {
  const MultipleImagesRequested({
    this.maxWidth,
    this.maxHeight,
    this.imageQuality,
    this.limit,
  });

  final double? maxWidth;
  final double? maxHeight;
  final int? imageQuality;
  final int? limit;

  @override
  List<Object?> get props => [maxWidth, maxHeight, imageQuality, limit];
}

final class LostImagesRecoveryRequested extends ImagePickerRequested {
  const LostImagesRecoveryRequested();
}

final class ImagePickerCleared extends ImagePickerEvent {
  const ImagePickerCleared();
}
