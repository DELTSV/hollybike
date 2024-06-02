import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/camera/qrcode_camera_screenshot.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrcodeCamera extends StatefulWidget {
  final void Function(String) onUrlFound;
  final bool Function(String?) urlValidator;

  const QrcodeCamera({
    super.key,
    required this.onUrlFound,
    required this.urlValidator,
  });

  @override
  State<QrcodeCamera> createState() => _QrcodeCameraState();
}

class _QrcodeCameraState extends State<QrcodeCamera>
    with WidgetsBindingObserver {
  final controller = MobileScannerController(
    autoStart: true,
    returnImage: true,
  );
  Uint8List? img;
  List<Offset>? linkCorners;
  StreamSubscription<Object?>? _subscription;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
        ),
        clipBehavior: Clip.hardEdge,
        child: SizedOverflowBox(
          size: Size.infinite,
          alignment: Alignment.center,
          child: MobileScanner(
            controller: controller,
            overlayBuilder: img == null ? null : _buildOverlay,
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context, BoxConstraints constraints) {
    return QrcodeCameraScreenshot(
      img: img as Uint8List,
      corners: linkCorners as List<Offset>,
      constraints: constraints,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = controller.barcodes.listen(_handleBarcode);
    unawaited(controller.start());
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) {
    final validBarcodes = _findLink(capture);
    if (validBarcodes != null && img == null) {
      widget.onUrlFound(validBarcodes.url?.url as String);

      setState(() {
        img = capture.image;
        linkCorners = validBarcodes.corners;
      });

      Timer(
        const Duration(seconds: 2),
        () {
          controller.start();
          setState(() {
            img = null;
            linkCorners = null;
          });
        },
      );
    }
  }

  Barcode? _findLink(BarcodeCapture capture) {
    try {
      final validLink = capture.barcodes.firstWhere(
        (barcode) => widget.urlValidator(barcode.url?.url),
      );

      return validLink;
    } catch (_) {
      return null;
    }
  }
}
