import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/camera/camera_preview_handler.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraLensDirection favoriteDirection = CameraLensDirection.back;

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    final camerasFuture = availableCameras();

    return FutureBuilder(
      future: camerasFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _renderCameras(snapshot.data);
        }
        return const Text("loading");
      },
    );
  }

  Widget _renderCameras(List<CameraDescription>? cameras) {
    if (cameras == null || cameras.isEmpty) {
      return const Text("Pas de cameras");
    }

    final camera = cameras.firstWhere(
      (camera) => camera.lensDirection == favoriteDirection,
      orElse: () => cameras.first,
    );
    return CameraPreviewHandler(camera: camera);
  }
}
