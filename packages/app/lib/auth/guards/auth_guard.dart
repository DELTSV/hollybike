/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:hollybike/app/app_router.gr.dart';

import '../services/auth_persistence.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthPersistence authPersistence;

  AuthGuard({required this.authPersistence});

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (await authPersistence.isDisconnected ||
        authPersistence.currentSessionExpired) {
      router.replaceAll([
        LoginRoute(onAuthSuccess: () {
          router.removeLast();
          resolver.next(true);
        }),
      ]);
    } else {
      resolver.next(true);
    }
  }
}
