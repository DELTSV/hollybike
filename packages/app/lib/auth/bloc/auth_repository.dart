import 'package:hollybike/auth/bloc/auth_api.dart';
import 'package:hollybike/auth/bloc/auth_persistence.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/auth/types/login_dto.dart';
import 'package:hollybike/auth/types/signup_dto.dart';

class AuthRepository {
  final AuthApi authApi;
  final AuthPersistence authPersistence;

  const AuthRepository({
    required this.authApi,
    required this.authPersistence,
  });

  Future<List<AuthSession>> retrievePersistedSessions() {
    return authPersistence.getSessions();
  }

  Future<AuthSession> login(String host, LoginDto dto) {
    return authApi.login(host, dto);
  }

  Future<AuthSession> signup(String host, SignupDto dto) {
    return authApi.signup(host, dto);
  }
}
