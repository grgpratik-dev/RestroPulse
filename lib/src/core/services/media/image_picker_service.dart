import 'package:image_picker/image_picker.dart';

/// Centralizes camera and photo-library access for the application.
///
/// Picked files live in temporary storage. Copy a file to permanent storage or
/// upload it before relying on it across app launches.
class ImagePickerService {
  ImagePickerService(ImagePicker picker) : _picker = picker;

  final ImagePicker _picker;

  Future<XFile?> pickFromGallery({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool requestFullMetadata = false,
  }) {
    return _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      requestFullMetadata: requestFullMetadata,
    );
  }

  Future<XFile?> takePhoto({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = false,
  }) {
    return _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
      requestFullMetadata: requestFullMetadata,
    );
  }

  Future<List<XFile>> pickMultipleFromGallery({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    bool requestFullMetadata = false,
  }) {
    return _picker.pickMultiImage(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      limit: limit,
      requestFullMetadata: requestFullMetadata,
    );
  }

  /// Recovers a selection if Android destroyed the activity while the picker
  /// was open. Call this during startup on screens that initiate image picks.
  Future<LostDataResponse> retrieveLostData() => _picker.retrieveLostData();
}
