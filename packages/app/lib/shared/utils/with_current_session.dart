import 'package:flutter/material.dart';
import 'package:hollybike/auth/bloc/auth_persistence.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:provider/provider.dart';

void withCurrentSession(
  BuildContext context,
  void Function(AuthSession session) callback,
) async {
  final currentSession = await Provider.of<AuthPersistence>(context, listen: false).currentSession;

  if (currentSession == null) {
    throw Exception("No current session available");
  }

  try {
    callback(currentSession);
  } catch (error) {
    rethrow;
  }
}
