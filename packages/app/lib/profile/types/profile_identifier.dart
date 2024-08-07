/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:hollybike/auth/types/auth_session.dart';

class ProfileIdentifier {
  final AuthSession session;
  final int? id;

  const ProfileIdentifier({required this.session, this.id});
}
