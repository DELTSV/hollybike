import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';

class AuthGuard extends AutoRouteGuard {
  final BuildContext context;

  AuthGuard({required this.context});

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final AuthState(
      :isPersistentSessionsLoaded,
      :currentSession,
    ) = BlocProvider.of<AuthBloc>(context).state;

    if (!isPersistentSessionsLoaded) {
      router.push(const LoadingRoute());
    } else if (currentSession == null) {
      router.push(LoginRoute(onAuthSuccess: () => resolver.next(true)));
    } else {
      resolver.next(true);
    }
  }
}
