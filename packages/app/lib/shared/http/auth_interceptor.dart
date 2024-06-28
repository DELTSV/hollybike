import 'package:dio/dio.dart';
import 'package:hollybike/auth/types/expired_session_exception.dart';

import '../../auth/bloc/auth_persistence.dart';
import '../../auth/types/auth_session.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthPersistence authPersistence;

  AuthInterceptor({required this.dio, required this.authPersistence});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final currentSession = await authPersistence.currentSession;
    if (currentSession is AuthSession) {
      print("host ${currentSession.host}");
      options.baseUrl = "${currentSession.host}/api";
      options.headers['Authorization'] = 'Bearer ${currentSession.token}';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final currentSession = await authPersistence.currentSession;

    if (err.response?.statusCode == 401 && currentSession is AuthSession) {
      final newSession = await _renewSession(currentSession);

      return handler.resolve(
        await dio.fetch(
          err.requestOptions.copyWith(
            headers: {'Authorization': 'Bearer ${newSession.token}'},
          ),
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

  Future<AuthSession> _renewSession(AuthSession oldSession) async {
    final newSessionResponse = await dio.patch(
      '${oldSession.host}/api/auth/refresh',
      data: {
        "device": oldSession.deviceId,
        "token": oldSession.refreshToken,
      },
    );

    if (newSessionResponse.statusCode != 200) {
      throw ExpiredSessionException(oldSession);
    }

    return AuthSession.fromResponseJson(
      oldSession.host,
      newSessionResponse.data,
    );
  }
}
