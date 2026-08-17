import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/camera_service_native.dart';
import '../services/camera_service_web.dart';
import '../services/image_service.dart';
import '../widgets/camera_view.dart';
import '../widgets/image_overlay.dart';
import '../widgets/control_panel.dart';

class ArDrawingScreen extends StatefulWidget {
  const ArDrawingScreen({super.key});

  @override
  State<ArDrawingScreen> createState() => _ArDrawingScreenState();
}

class _ArDrawingScreenState extends State<ArDrawingScreen>
    with WidgetsBindingObserver {
  dynamic _cameraController;
  CameraServiceNative? _nativeCameraService;
  CameraServiceWeb? _webCameraService;
  late ImageService _imageService;

  ImageData? _selectedImage;
  List<int>? _selectedImageBytes;
  Offset _imagePosition = Offset.zero;
  double _imageScale = 1.0;
  double _imageRotation = 0.0;
  double _imageOpacity = 0.65;

  bool _isInitialized = false;
  String? _initError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      _imageService = ImageService();
      
      if (kIsWeb) {
        _webCameraService = CameraServiceWeb();
        await _webCameraService!.initialize();
        _cameraController = _webCameraService;
      } else {
        _nativeCameraService = CameraServiceNative();
        await _nativeCameraService!.initialize();
        _cameraController = _nativeCameraService!.controller;
      }
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _initError = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (kIsWeb) {
      _webCameraService?.dispose();
    } else {
      _nativeCameraService?.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isInitialized || kIsWeb) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _nativeCameraService?.controller.startImageStream((_) {});
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _nativeCameraService?.controller.stopImageStream();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  Future<void> _pickImage() async {
    try {
      final imageData = await _imageService.pickImageFromGallery();
      if (imageData != null && mounted) {
        final bytes = await imageData.getBytes();
        setState(() {
          _selectedImage = imageData;
          _selectedImageBytes = bytes;
          _resetImageTransform();
        });
      }
    } catch (e) {
      _showErrorSnackBar('Erro ao selecionar imagem: $e');
    }
  }

  void _resetImageTransform() {
    setState(() {
      _imagePosition = Offset.zero;
      _imageScale = 1.0;
      _imageRotation = 0.0;
      _imageOpacity = 0.65;
    });
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _selectedImageBytes = null;
      _resetImageTransform();
    });
  }



double _startingScale = 1.0;

void _onScaleStart(ScaleStartDetails details) {
  _startingScale = _imageScale;
}

void _onScaleUpdate(ScaleUpdateDetails details) {
  setState(() {
    _imagePosition += details.focalPointDelta;
    _imageScale =
        (_startingScale * details.scale).clamp(0.1, 5.0);
  });
}

  void _onRotationUpdate(double degrees) {
    setState(() {
      _imageRotation = degrees;
    });
  }

  void _onOpacityChanged(double value) {
    setState(() {
      _imageOpacity = value;
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_initError != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Erro: $_initError',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                )
              else
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraView(controller: _cameraController),
          if (_selectedImage != null && _selectedImageBytes != null)
            GestureDetector(
            onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              child: SizedBox.expand(
                child: Stack(
                  children: [
                    Positioned(
                      left: _imagePosition.dx,
                      top: _imagePosition.dy,
                      child: Transform.rotate(
                        angle: _imageRotation * pi / 180,
                        child: Transform.scale(
                          scale: _imageScale,
                          child: Opacity(
                            opacity: _imageOpacity,
                            child: Image.memory(
                              Uint8List.fromList(_selectedImageBytes!),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ImageOverlay(
              image: null,
              imageBytes: null,
              position: _imagePosition,
              scale: _imageScale,
              rotation: _imageRotation,
              opacity: _imageOpacity,
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'AR DRAWING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      if (_selectedImage != null)
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.refresh, color: Colors.white),
                              onPressed: _resetImageTransform,
                              tooltip: 'Reset',
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: _removeImage,
                              tooltip: 'Remover imagem',
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ControlPanel(
              opacity: _imageOpacity,
              rotation: _imageRotation,
              onOpacityChanged: () {},
              onRotationChanged: () {},
              onReset: _resetImageTransform,
              onPickImage: _pickImage,
              onRemoveImage: _removeImage,
              hasImage: _selectedImage != null,
              onOpacitySliderChanged: _onOpacityChanged,
              onRotationSliderChanged: _onRotationUpdate,
            ),
          ),
        ],
      ),
    );
  }
}
