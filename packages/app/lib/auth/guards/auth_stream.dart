import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_persistence.dart';
import 'package:hollybike/auth/bloc/auth_session_repository.dart';

class AuthStream extends ChangeNotifier {
  AuthStream(BuildContext context, {required AuthPersistence authPersistence}) {
    RepositoryProvider.of<AuthSessionRepository>(context).authSessionStream.listen((state) {
      if (state == null) {
        notifyListeners();
      }
    });

    authPersistence.currentSessionExpiredStream.listen((_) {
      notifyListeners();
    });
  }
}
