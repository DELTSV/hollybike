/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:permission_handler/permission_handler.dart';

extension RequestAndCheck on Permission {
  Future<bool> requestAndCheck() async {
    final status = await request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      return openAppSettings();
    }

    return false;
  }
}
