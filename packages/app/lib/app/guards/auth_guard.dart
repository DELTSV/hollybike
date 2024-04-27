import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/app/app_router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  final BuildContext context;

  AuthGuard({required this.context});

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final token = context.read<AuthBloc>().state.token;
    if (token != null) {
      resolver.next(true);
    } else {
      router.push(AuthRoute(onAuthSuccess: () => resolver.next(true)));
    }
  }
}
