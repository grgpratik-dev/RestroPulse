part of 'image_picker_bloc.dart';

enum ImagePickerStatus { initial, picking, success, cancelled, failure }

final class ImagePickerState extends Equatable {
  const ImagePickerState({
    this.status = ImagePickerStatus.initial,
    this.images = const [],
    this.errorMessage,
  });

  final ImagePickerStatus status;
  final List<XFile> images;
  final String? errorMessage;

  XFile? get image => images.firstOrNull;

  ImagePickerState copyWith({
    ImagePickerStatus? status,
    List<XFile>? images,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ImagePickerState(
      status: status ?? this.status,
      images: images ?? this.images,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, images, errorMessage];
}
