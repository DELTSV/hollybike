import 'package:dio/dio.dart';
import 'package:hollybike/auth/bloc/auth_persistence.dart';

import 'auth_interceptor.dart';

class DioClient {
  final Dio dio;
  final AuthPersistence? authPersistence;
  final String? host;

  DioClient({this.authPersistence, this.host}) : dio = Dio() {
    addInterceptor(LogInterceptor());
  }

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
    if (authPersistence is AuthPersistence) {
      print("authPersistence detected");
      dio.interceptors.add(AuthInterceptor(
        dio: dio,
        authPersistence: authPersistence as AuthPersistence,
      ));
    }
  }
}
