import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/bloc/auth_session_repository.dart';

class AuthStream extends ChangeNotifier {
  AuthStream(BuildContext context) {
    RepositoryProvider.of<AuthSessionRepository>(context).authSessionStream.listen((state) {
      switch (state.runtimeType) {
        case AuthDisconnected _:
          notifyListeners();
      }
    });
  }
}
