/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';
import 'package:hollybike/auth/services/auth_session_repository.dart';

class AuthStream extends ChangeNotifier {
  AuthStream(BuildContext context, {required AuthPersistence authPersistence}) {
    RepositoryProvider.of<AuthSessionRepository>(context)
        .authSessionStream
        .listen((state) {
      if (state == null) {
        notifyListeners();
      }
    });

    authPersistence.currentSessionExpiredStream.listen((_) {
      notifyListeners();
    });
  }
}
