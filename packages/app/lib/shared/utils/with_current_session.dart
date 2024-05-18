import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/types/auth_session.dart';

import '../../auth/bloc/auth_bloc.dart';

void withCurrentSession(BuildContext context, void Function(AuthSession session) callback) {
  final authBloc = BlocProvider.of<AuthBloc>(context);

  if (authBloc.state.currentSession == null) {
    throw Exception("No current session available");
  }

  try {
    callback(authBloc.state.currentSession!);
  } catch (error) {
    rethrow;
  }
}