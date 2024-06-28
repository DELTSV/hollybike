import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/app/app_router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthPersistence authPersistence;

  AuthGuard({required this.authPersistence});

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (await authPersistence.isDisconnected) {
      router.push(LoginRoute(onAuthSuccess: () => resolver.next(true)));
    } else {
      resolver.next(true);
    }
  }
}
