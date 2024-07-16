/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:hollybike/auth/types/auth_session.dart';

class ExpiredSessionException implements Exception {
  final String message;

  ExpiredSessionException(AuthSession expiredSession)
      : message = "Current session to ${expiredSession.host} cannot be renewed";
}
