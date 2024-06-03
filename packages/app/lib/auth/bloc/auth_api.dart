import 'package:hollybike/auth/types/login_dto.dart';
import 'package:hollybike/auth/types/signup_dto.dart';
import 'package:http/http.dart';

class AuthApi {
  Future<Response> login(String host, LoginDto dto) {
    final uri = Uri.parse("$host/api/auth/login");
    return post(
      uri,
      body: dto.asJson(),
      headers: {
        'Content-Type': "application/json",
      },
    );
  }

  Future<Response> signup(String host, SignupDto dto) {
    final uri = Uri.parse("$host/api/auth/signin");
    return post(
      uri,
      body: dto.asJson(),
      headers: {
        'Content-Type': "application/json",
      },
    );
  }
}
