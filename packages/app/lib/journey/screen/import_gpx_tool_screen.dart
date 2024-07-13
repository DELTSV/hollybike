import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hollybike/shared/utils/safe_set_state.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

@RoutePage()
class ImportGpxToolScreen extends StatefulWidget {
  final String url;
  final void Function(File) onGpxDownloaded;
  final void Function() onClose;

  const ImportGpxToolScreen({
    super.key,
    required this.url,
    required this.onGpxDownloaded,
    required this.onClose,
  });

  @override
  State<ImportGpxToolScreen> createState() => _ImportGpxToolScreenState();
}

class _ImportGpxToolScreenState extends State<ImportGpxToolScreen> {
  InAppWebViewController? _controller;

  bool _popped = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) async {
        if (_popped) {
          return;
        }

        final canPopInWebView = await canPopFromController();

        if (canPopInWebView) {
          _controller?.goBack();
          return;
        }

        safeSetState(() {
          _popped = true;
        });

        widget.onClose();
      },
      child: Scaffold(
        body: SafeArea(
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse(widget.url),
            ),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useOnDownloadStart: true,
                useShouldInterceptFetchRequest: true,
              ),
            ),
            onWebViewCreated: (controller) {
              _controller = controller;
            },
            onLoadStart: (controller, url) {},
            onLoadStop: (controller, url) {},
            shouldInterceptFetchRequest: (controller, request) async {
              final url = request.url.toString();

              final isKurvigerFile =
                  url.startsWith("https://api.kurviger.de/route");
              final isOpenrunnerFile =
                  url.startsWith("https://api.openrunner.com/api/v2/routes/") &&
                      url.endsWith("/export/gpx-track");

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

                widget.onGpxDownloaded(
                  writeTempFile(response.bodyBytes),
                );

                return Future.value(null);
              }

              return Future.value(request);
            },
            onDownloadStartRequest: (controller, data) async {
              if (widget.url.contains('kurviger')) {
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

                widget.onGpxDownloaded(
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

              widget.onGpxDownloaded(
                writeTempFile(response.bodyBytes),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> canPopFromController() async {
    if (_controller == null) {
      return false;
    }

    return _controller!.canGoBack();
  }

  File writeTempFile(List<int> bytes) {
    final tempDir = Directory.systemTemp;
    final filePath = path.join(tempDir.path, 'hollybike-temp.gpx');
    final file = File(filePath);
    file.writeAsBytesSync(bytes);

    return file;
  }
}
