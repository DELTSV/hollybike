import 'package:dio/dio.dart';
import 'package:hollybike/auth/types/auth_session.dart';

import 'interceptors/auth_interceptor.dart';

class DioClient {
  final AuthSession session;
  late final Dio dio;

  DioClient(this.session) {
    dio = Dio(
      BaseOptions(baseUrl: '${session.host}/api'),
    );

    addInterceptor(LogInterceptor());
  }

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(AuthInterceptor(dio: dio, token: session.token));
    dio.interceptors.add(interceptor);
  }
}