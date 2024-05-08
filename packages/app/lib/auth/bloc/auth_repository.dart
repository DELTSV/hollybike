import 'package:hollybike/auth/bloc/auth_api.dart';
import 'package:hollybike/auth/types/login_dto.dart';
import 'package:http/http.dart';

class AuthRepository {
  final AuthApi authApi;

  const AuthRepository({required this.authApi});

  Future<Response> login(String host, LoginDto dto) {
    return authApi.login(host, dto);
  }
}
