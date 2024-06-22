import 'package:dio/dio.dart';
import 'package:hollybike/auth/types/auth_session.dart';

import 'interceptors/auth_interceptor.dart';

class DioClient {
  final AuthSession? session;
  late final Dio dio;

  DioClient(this.session, {String? host}) {
    if (host == null && session == null) {
      throw Exception(
        "You must provide a at least an host string to DioClient if session is null",
      );
    }

    dio = Dio(
      BaseOptions(baseUrl: '${session?.host ?? host}/api'),
    );

    addInterceptor(LogInterceptor());
  }

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
    if (session is AuthSession) {
      dio.interceptors.add(AuthInterceptor(dio: dio, token: session?.token));
    }
  }
}
