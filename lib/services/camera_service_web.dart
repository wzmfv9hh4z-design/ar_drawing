import 'camera_service.dart';

/// Web camera service for Flutter Web
/// Uses browser's getUserMedia API to access camera
class CameraServiceWeb implements ICameraService {
  /// Whether initialization is complete
  bool _isInitialized = false;
  
  /// Whether currently using front camera
  bool _isFrontCamera = false;

  @override
  bool get isInitialized => _isInitialized;
  
  @override
  bool get hasMultipleCameras => true;

  @override
  Future<void> initialize() async {
    try {
      await _initializeWeb();
      _isInitialized = true;
    } catch (e) {
      throw Exception('Web camera initialization failed: $e');
    }
  }

  /// Platform-specific web initialization - stub for now
  /// Will be enhanced with actual getUserMedia integration
  Future<void> _initializeWeb() async {
    // Camera will be initialized via JavaScript in index.html
    // This prevents dart:html import issues during web compilation
  }

  @override
  Future<void> switchCamera() async {
    try {
      _isFrontCamera = !_isFrontCamera;
      await _initializeWeb();
    } catch (e) {
      throw Exception('Camera switch failed: $e');
    }
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
  }
}
