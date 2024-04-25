import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:hollybike/router/app_router.gr.dart';
import 'package:hollybike/router/guards/auth_guard.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  final BuildContext context;

  AppRouter({required this.context});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
            page: HomeRoute.page,
            initial: true,
            guards: [AuthGuard(context: context)]),
        AutoRoute(page: AuthRoute.page, path: '/auth'),
      ];
}
