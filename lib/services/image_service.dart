import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImageData {
  /// Get image bytes for display
  Future<List<int>> getBytes();
}

class NativeImageData extends ImageData {
  final XFile file;

  NativeImageData(this.file);

  @override
  Future<List<int>> getBytes() async {
    return await file.readAsBytes();
  }
}

class WebImageData extends ImageData {
  final XFile file;

  WebImageData(this.file);

  @override
  Future<List<int>> getBytes() async {
    return await file.readAsBytes();
  }
}

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<ImageData?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      
      if (image != null) {
        if (kIsWeb) {
          return WebImageData(image);
        } else {
          return NativeImageData(image);
        }
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}


