/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';
import 'package:hollybike/shared/utils/dowload_folder.dart';

class Downloader {
  final AuthPersistence authPersistence;

  Downloader({required this.authPersistence});

  Future<void> downloadFile(
    String route,
    String fileName, {
    bool authenticate = false,
    Map<String, String> extraHeaders = const {},
  }) async {
    final currentSession =
        authenticate ? await authPersistence.currentSession : null;

    if (currentSession == null && authenticate) {
      throw Exception('No session found');
    }

    final url = authenticate ? '${currentSession!.host}/api$route' : route;

    final headers = authenticate
        ? {'Authorization': 'Bearer ${currentSession!.token}', ...extraHeaders}
        : extraHeaders;

    final downloadPath = await getDownloadPath();

    if (downloadPath == null) {
      throw Exception('Download path not found');
    }

    await FlutterDownloader.enqueue(
      url: url,
      headers: headers,
      savedDir: downloadPath,
      fileName: fileName,
      showNotification: true,
      openFileFromNotification: true,
    );
  }
}
