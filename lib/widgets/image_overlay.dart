import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/image_service.dart';

class ImageOverlay extends StatelessWidget {
  final ImageData? image;
  final List<int>? imageBytes;
  final Offset position;
  final double scale;
  final double rotation;
  final double opacity;

  const ImageOverlay({
    required this.image,
    required this.imageBytes,
    required this.position,
    required this.scale,
    required this.rotation,
    required this.opacity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (image == null || imageBytes == null) {
      return const SizedBox.expand();
    }

    final bytes = Uint8List.fromList(imageBytes!);

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Transform.rotate(
              angle: rotation,
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Image.memory(
                    bytes,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

