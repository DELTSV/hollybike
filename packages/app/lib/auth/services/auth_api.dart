import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/auth/types/login_dto.dart';
import 'package:hollybike/auth/types/signup_dto.dart';
import 'package:hollybike/shared/http/dio_client.dart';

class AuthApi {
  Future<AuthSession> login(String host, LoginDto dto) async {
    final response = await DioClient(host: host)
        .dio
        .post("$host/api/auth/login", data: dto.asJson());

    return AuthSession.fromResponseJson(host, response.data);
  }

  Future<AuthSession> signup(String host, SignupDto dto) async {
    final response = await DioClient(host: host)
        .dio
        .post("$host/api/auth/signin", data: dto.asJson());

    return AuthSession.fromResponseJson(host, response.data);
  }
}
