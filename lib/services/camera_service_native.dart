import 'package:camera/camera.dart';
import 'camera_service.dart';

class CameraServiceNative implements ICameraService {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  int _currentCameraIndex = 0;
  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;
  
  CameraController get controller => _controller;
  List<CameraDescription> get cameras => _cameras;
  int get currentCameraIndex => _currentCameraIndex;
  
  @override
  bool get hasMultipleCameras => _cameras.length > 1;

  @override
  Future<void> initialize() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) {
      throw Exception('No cameras available');
    }
    await _initializeCamera(0);
    _isInitialized = true;
  }

  Future<void> _initializeCamera(int cameraIndex) async {
    _currentCameraIndex = cameraIndex;
    final camera = _cameras[cameraIndex];
    
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller.initialize();
  }

  @override
  Future<void> switchCamera() async {
    if (!hasMultipleCameras) return;
    
    final newIndex = (_currentCameraIndex + 1) % _cameras.length;
    await _controller.dispose();
    await _initializeCamera(newIndex);
  }

  @override
  Future<void> dispose() async {
    await _controller.dispose();
    _isInitialized = false;
  }
}
