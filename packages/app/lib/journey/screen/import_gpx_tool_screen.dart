import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:http/http.dart' as http;

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

@RoutePage()
class ImportGpxToolScreen extends StatelessWidget {
  final String url;
  final void Function(File) onGpxDownloaded;

  const ImportGpxToolScreen({
    super.key,
    required this.url,
    required this.onGpxDownloaded,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(url),
        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useOnDownloadStart: true,
            useShouldInterceptFetchRequest: true,
          ),
        ),
        onWebViewCreated: (controller) {
          // webView = controller;
        },
        onLoadStart: (controller, url) {},
        onLoadStop: (controller, url) {},
        shouldInterceptFetchRequest: (controller, request) async {
          final url = request.url.toString();

          final isKurvigerFile = url.startsWith("https://api.kurviger.de/route/");
          final isOpenrunnerFile = url.startsWith("https://api.openrunner.com/api/v2/routes/") && url.endsWith("/export/gpx-track");

          if (isKurvigerFile || isOpenrunnerFile) {
            final response = await http.get(
              Uri.parse(url),
              headers: {
                'User-Agent': request.headers?['User-Agent'] ?? '',
                'Accept': request.headers?['Accept'] ?? '',
              },
            );

            if (response.body.contains('<gpx') == false) {
              return Future.value(request);
            }

            onGpxDownloaded(
              writeTempFile(response.bodyBytes),
            );

            return Future.value(null);
          }

          return Future.value(request);
        },
        onDownloadStartRequest: (controller, data) async {
          if (url.contains('kurviger')) {
            return;
          }

          final requestUrl = data.url.toString();

          if (requestUrl.startsWith('data:text')) {
            final cleanUrl = requestUrl.replaceAll(
              RegExp(r'data:text.*?,'),
              '',
            );

            final decoded = Uri.decodeFull(cleanUrl);

            if (decoded.contains('<gpx') == false) {
              return;
            }

            onGpxDownloaded(
              writeTempFile(decoded.codeUnits),
            );

            return;
          }

          final uri = Uri.parse(requestUrl.replaceAll('blob:', ''));

          final response = await http.get(uri, headers: {
            'User-Agent': data.userAgent ?? '',
            'Accept': data.mimeType ?? '',
          });

          if (response.body.contains('<gpx') == false) {
            return;
          }

          onGpxDownloaded(
            writeTempFile(response.bodyBytes),
          );
        },
      ),
    );
  }

  File writeTempFile(List<int> bytes) {
    final tempDir = Directory.systemTemp;
    final filePath = path.join(tempDir.path, 'hollybike-temp.gpx');
    final file = File(filePath);
    file.writeAsBytesSync(bytes);

    return file;
  }
}
