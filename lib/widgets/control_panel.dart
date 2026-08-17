import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  final double opacity;
  final double rotation;
  final VoidCallback onOpacityChanged;
  final VoidCallback onRotationChanged;
  final VoidCallback onReset;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;
  final bool hasImage;
  final Function(double) onOpacitySliderChanged;
  final Function(double) onRotationSliderChanged;

  const ControlPanel({
    required this.opacity,
    required this.rotation,
    required this.onOpacityChanged,
    required this.onRotationChanged,
    required this.onReset,
    required this.onPickImage,
    required this.onRemoveImage,
    required this.hasImage,
    required this.onOpacitySliderChanged,
    required this.onRotationSliderChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasImage) ...[
                // Opacity Control
                Row(
                  children: [
                    const Icon(Icons.opacity, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Slider(
                        value: opacity,
                        min: 0.05,
                        max: 1.0,
                        divisions: 19,
                        activeColor: Colors.blueAccent,
                        inactiveColor: Colors.white24,
                        onChanged: onOpacitySliderChanged,
                      ),
                    ),
                    Text(
                      '${(opacity * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Rotation Control
                Row(
                  children: [
                    const Icon(Icons.rotate_right, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Slider(
                        value: rotation,
                        min: 0,
                        max: 360,
                        divisions: 36,
                        activeColor: Colors.blueAccent,
                        inactiveColor: Colors.white24,
                        onChanged: onRotationSliderChanged,
                      ),
                    ),
                    Text(
                      '${rotation.toStringAsFixed(0)}°',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: onPickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Escolher imagem'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  if (hasImage) ...[
                    ElevatedButton.icon(
                      onPressed: onReset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: onRemoveImage,
                      icon: const Icon(Icons.delete),
                      label: const Text('Remover'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
