import 'package:hollybike/auth/types/auth_session.dart';

typedef AuthHandler = ({
  AuthSession session,
  void Function(
    AuthSession oldSession,
    AuthSession newSession,
  ) onSessionInvalidated,
});
