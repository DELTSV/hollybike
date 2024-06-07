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
        CustomRoute(
          initial: true,
          guards: [AuthGuard(context: context)],
          page: EventsRoute.page,
          path: '/events',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          guards: [AuthGuard(context: context)],
          page: EventDetailsRoute.page,
          path: '/event-details',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          guards: [AuthGuard(context: context)],
          page: EventParticipationsRoute.page,
          path: '/event-participations',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          guards: [AuthGuard(context: context)],
          page: EventCandidatesRoute.page,
          path: '/event-candidates',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          guards: [AuthGuard(context: context)],
          page: MyEventsRoute.page,
          path: '/my-events',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          guards: [AuthGuard(context: context)],
          page: ProfileRoute.page,
          path: '/profile',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
        ),
        AutoRoute(
          page: SignupRoute.page,
          path: '/invite',
        ),
        AutoRoute(
          page: LoadingRoute.page,
          path: '/load',
        ),
        RedirectRoute(path: '*', redirectTo: 'events'),
      ];
}
