import 'package:hollybike/auth/types/auth_session.dart';
import 'package:rxdart/rxdart.dart';

class AuthSessionRepository {
  final Subject<AuthSession> _expirationSubject = BehaviorSubject();

  Stream<AuthSession> get expirationStream => _expirationSubject.stream;

  final Subject<AuthSession?> _currentSessionSubject = BehaviorSubject();

  Stream<AuthSession?> get currentSessionStream =>
      _currentSessionSubject.stream;

  AuthSessionRepository();

  void sessionExpired(AuthSession session) {
    _expirationSubject.add(session);
  }

  void setCurrentSession(AuthSession? session) {
    _currentSessionSubject.add(session);
  }
}
