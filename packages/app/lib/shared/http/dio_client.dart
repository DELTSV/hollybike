import 'package:dio/dio.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/shared/types/auth_handler.dart';

import 'interceptors/auth_interceptor.dart';

class DioClient {
  final AuthHandler? _authHandler;
  late final Dio dio;

  DioClient(this._authHandler, {String? host}) {
    if (host == null && _authHandler == null) {
      throw Exception(
        "You must provide a at least an host string to DioClient if session is null",
      );
    }

    dio = Dio(
      BaseOptions(baseUrl: '${_authHandler?.session.host ?? host}/api'),
    );

    addInterceptor(LogInterceptor());
  }

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
    if (_authHandler is AuthHandler) {
      dio.interceptors.add(AuthInterceptor(dio: dio, authHandler: _authHandler));
    }
  }
}
