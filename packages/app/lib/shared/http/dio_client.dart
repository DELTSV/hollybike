/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:dio/dio.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';

import 'auth_interceptor.dart';

class DioClient {
  final Dio dio;
  final AuthPersistence? authPersistence;
  final String? host;

  DioClient({this.authPersistence, this.host}) : dio = Dio() {
    addInterceptor(LogInterceptor());

    if (host != null) {
      dio.options.baseUrl = host!;
    }
  }

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
    if (authPersistence is AuthPersistence) {
      dio.interceptors.add(AuthInterceptor(
        dio: dio,
        authPersistence: authPersistence as AuthPersistence,
      ));
    }
  }
}
