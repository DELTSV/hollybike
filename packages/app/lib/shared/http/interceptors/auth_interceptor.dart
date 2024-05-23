import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final String? token;

  AuthInterceptor({
    required this.dio,
    required this.token,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

// Pour les refresh tokens
// @override
// void onError(DioException err, ErrorInterceptorHandler handler) async {
//   if (err.response?.statusCode == 401) {
//     // Refresh the token if the request results with status code of 401.
//     return handler
//         .resolve(await dio.fetch(err.requestOptions)); // Repeat the request.
//   }
//
//   return handler.reject(DioException(
//     requestOptions: err.requestOptions,
//     error: err.response,
//   ));
// }
}
