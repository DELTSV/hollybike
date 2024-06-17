import 'package:flutter/cupertino.dart';

import '../../../auth/types/auth_session.dart';

@immutable
abstract class JourneysLibraryEvent {}

class LoadJourneysLibraryNextPage extends JourneysLibraryEvent {
  final AuthSession session;

  LoadJourneysLibraryNextPage({
    required this.session,
  });
}

class RefreshJourneysLibrary extends JourneysLibraryEvent {
  final AuthSession session;

  RefreshJourneysLibrary({
    required this.session,
  });
}