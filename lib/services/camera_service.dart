import 'package:flutter/foundation.dart';

abstract class ICameraService {
  bool get isInitialized;
  bool get hasMultipleCameras;
  
  Future<void> initialize();
  Future<void> switchCamera();
  Future<void> dispose();
}

class CameraService {
  static late ICameraService _instance;
  static bool _initialized = false;
  
  static Future<ICameraService> getInstance() async {
    if (!_initialized) {
      if (kIsWeb) {
        // Import will be resolved at compile time based on platform
        // For web, we use CameraServiceWeb
        // This is handled by the platform-specific implementation
      } else {
        // For native (iOS/Android), we use CameraServiceNative
      }
      _initialized = true;
    }
    return _instance;
  }

  static void setInstance(ICameraService instance) {
    _instance = instance;
  }

  static ICameraService get instance => _instance;
}



