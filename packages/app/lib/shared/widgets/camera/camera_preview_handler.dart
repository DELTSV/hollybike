import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPreviewHandler extends StatefulWidget {
  final CameraDescription camera;

  const CameraPreviewHandler({super.key, required this.camera});

  @override
  State<CameraPreviewHandler> createState() => _CameraPreviewHandlerState();
}

class _CameraPreviewHandlerState extends State<CameraPreviewHandler> {
  late final CameraController _controller;
  late final Future<void> _initializeControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_controller);
        }
        return const Placeholder();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
