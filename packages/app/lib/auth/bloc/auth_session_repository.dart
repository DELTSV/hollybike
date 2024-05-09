import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/auth_session.dart';

class AuthSessionRepository {
  final AuthBloc authBloc;

  const AuthSessionRepository({required this.authBloc});

  void sessionExpired(AuthSession session) {
    print("expired session");
    authBloc.add(AuthSessionExpired(expiredSession: session));
  }
}
