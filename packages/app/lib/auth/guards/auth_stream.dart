import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';

class AuthStream extends ChangeNotifier {
  AuthStream(BuildContext context) {
    context.watch<AuthBloc>().stream.listen((event) {
      switch (event) {
        case AuthState(
              isPersistentSessionsLoaded: final isLoaded,
              currentSession: final session,
            )
            when session == null || isLoaded == false:
          notifyListeners();
      }
    });
  }
}
