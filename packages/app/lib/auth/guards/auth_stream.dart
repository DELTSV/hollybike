import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';

class AuthStream extends ChangeNotifier {
  late final StreamSubscription<AuthState> _authStream;

  AuthStream(BuildContext context) {
    _authStream = context.watch<AuthBloc>().stream.listen((event) {
      notifyListeners();
    });
  }
}
