import 'package:dio/dio.dart';

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
      if (options.baseUrl.isEmpty) {
        options.baseUrl = "${currentSession.host}/api";
      }

      if (options.headers['Authorization'] == null) {
        options.headers['Authorization'] = 'Bearer ${currentSession.token}';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    void reject() {
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: err.response,
        ),
      );
    }

    final authHeader = err.requestOptions.headers['Authorization'];
    final token = authHeader?.replaceFirst('Bearer ', '');

    if (token == null) {
      return reject();
    }

    final requestSession = await authPersistence.getSessionByToken(token);

    if (requestSession == null) {
      return reject();
    }

    if (err.response?.statusCode == 401) {
      AuthSession? newSession;

      try {
        if (authPersistence.refreshing) {
          await authPersistence.waitIfRefreshing();
          newSession = authPersistence.getNewSession(requestSession);
        } else {
          authPersistence.refreshing = true;
          newSession = await _renewSession(requestSession).then(
            (value) {
              return authPersistence.replaceSession(requestSession, value).then(
                (_) => value,
              );
            },
          ).onError(
            (error, stackTrace) {
              authPersistence.removeCorrespondence(requestSession);
              return Future.error(error!);
            },
          ).whenComplete(() {
            authPersistence.refreshing = false;
          });
        }

        if (newSession == null) {
          return reject();
        }

        try {
          final response = await dio.fetch(
            err.requestOptions.copyWith(
              headers: {'Authorization': 'Bearer ${newSession.token}'},
            ),
          );

          return handler.resolve(response);
        } on DioException catch (e) {
          if (e.response?.statusCode == 401) {
            await onSessionExpired(requestSession);
          }

          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: e.response,
            ),
          );
        }
      } on DioException catch (e) {
        await onSessionExpired(requestSession);

        return handler.reject(
          DioException(
            requestOptions: e.requestOptions,
            error: e.response,
          ),
        );
      }
    }

    return reject();
  }

  Future<void> onSessionExpired(AuthSession session) async {
    final currentSession = await authPersistence.currentSession;

    if (currentSession == session) {
      authPersistence.expiredCurrentSession = session;
    }

    await authPersistence.removeSession(session);
  }

  Future<AuthSession> _renewSession(AuthSession oldSession) async {
    final newSessionResponse = await dio.patch(
      '${oldSession.host}/api/auth/refresh',
      data: {
        "device": oldSession.deviceId,
        "token": oldSession.refreshToken,
      },
    );

    return AuthSession.fromResponseJson(
      oldSession.host,
      newSessionResponse.data,
    );
  }
}
