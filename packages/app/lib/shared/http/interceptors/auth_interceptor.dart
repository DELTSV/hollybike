import 'package:dio/dio.dart';
import 'package:hollybike/shared/types/auth_handler.dart';

import '../../../auth/types/auth_session.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthHandler? authHandler;

  AuthInterceptor({
    required this.dio,
    required this.authHandler,
  });

  @override
  void onRequest(RequestOptions options,
      RequestInterceptorHandler handler,) async {
    if (authHandler is AuthHandler) {
      options.headers['Authorization'] = 'Bearer ${authHandler!.session.token}';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && authHandler is AuthHandler) {
      final newSession

      return handler.resolve(
        await dio.fetch(
          err.requestOptions.copyWith(headers: {}),
        ),
      );
    }

    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: err.response,
      ),
    );
  }

  Future<AuthSession> _renewSession(AuthSession oldSession) {
    final renewSessionDio = Dio(
        BaseOptions(baseUrl: '${oldSession.host}/api/auth/refresh'),
    );

    final newSessionResponse = renewSessionDio
  }
}
