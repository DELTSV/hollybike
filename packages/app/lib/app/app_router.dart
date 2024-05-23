import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/auth/guards/auth_guard.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  final BuildContext context;

  AppRouter({required this.context});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: NotificationRoute.page,
          initial: true,
          children: [
            AutoRoute(
              page: LoadingRoute.page,
              path: 'load',
            ),
            AutoRoute(
              guards: [AuthGuard(context: context)],
              page: HudRoute.page,
              initial: true,
              children: [
                RedirectRoute(path: '', redirectTo: 'events'),
                AutoRoute(
                  page: EventsRoute.page,
                  path: 'events',
                ),
                CustomRoute(
                  page: EventDetailsRoute.page,
                  path: 'event-details',
                  transitionsBuilder: TransitionsBuilders.fadeIn,
                )
              ],
            ),
            AutoRoute(
              page: AuthRoute.page,
              path: 'auth',
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
                AutoRoute(
                  page: ForgotPasswordRoute.page,
                  path: 'forgot-password',
                ),
              ],
            ),
          ],
        ),
      ];
}
