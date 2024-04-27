import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/app/guards/auth_guard.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  final BuildContext context;

  AppRouter({required this.context});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: HomeRoute.page,
          initial: true,
          guards: [AuthGuard(context: context)],
        ),
        AutoRoute(
          page: AuthRoute.page,
          path: '/auth',
          children: [
            RedirectRoute(path: '', redirectTo: 'login'),
            AutoRoute(
              page: LoginRoute.page,
              path: 'login',
            ),
            AutoRoute(
              page: SignupRoute.page,
              path: 'signup',
            ),
          ],
        ),
      ];
}
