import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/camera_service_web.dart';

class CameraView extends StatefulWidget {
  final dynamic controller; // Can be CameraController or CameraServiceWeb

  const CameraView({
    required this.controller,
    super.key,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      final cameraServiceWeb = widget.controller as CameraServiceWeb;
      if (!cameraServiceWeb.isInitialized) {
        return Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );
      }
      
      // Web camera display - will show live feed via JavaScript
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            'Camera Stream (Loading...)',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      // Native implementation
      final cameraController = widget.controller as CameraController;
      if (!cameraController.value.isInitialized) {
        return Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );
      }

      return SizedBox.expand(
        child: CameraPreview(cameraController),
      );
    }
  }
}

