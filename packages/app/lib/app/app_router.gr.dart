// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i11;
import 'package:hollybike/auth/routes/auth_route.dart' as _i1;
import 'package:hollybike/auth/routes/forgot_password_route.dart' as _i4;
import 'package:hollybike/auth/routes/login_route.dart' as _i7;
import 'package:hollybike/auth/routes/signup_route.dart' as _i9;
import 'package:hollybike/event/screens/event_details_screen.dart' as _i2;
import 'package:hollybike/event/screens/events_screen.dart' as _i3;
import 'package:hollybike/event/widgets/event_image.dart' as _i12;
import 'package:hollybike/hud/routes/hud_route.dart' as _i5;
import 'package:hollybike/notification/routes/notification_route.dart' as _i8;
import 'package:hollybike/shared/routes/loading_route.dart' as _i6;

abstract class $AppRouter extends _i10.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    AuthRoute.name: (routeData) {
      final args = routeData.argsAs<AuthRouteArgs>();
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AuthRoute(
          key: args.key,
          onAuthSuccess: args.onAuthSuccess,
        ),
      );
    },
    EventDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<EventDetailsRouteArgs>();
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.EventDetailsScreen(
          key: args.key,
          eventId: args.eventId,
          eventImage: args.eventImage,
        ),
      );
    },
    EventsRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.EventsScreen(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.ForgotPasswordRoute(),
      );
    },
    HudRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.HudRoute(),
      );
    },
    LoadingRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.LoadingRoute(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.LoginRoute(),
      );
    },
    NotificationRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.NotificationRoute(),
      );
    },
    SignupRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.SignupRoute(),
      );
    },
  };
}

/// generated route for
/// [_i1.AuthRoute]
class AuthRoute extends _i10.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({
    _i11.Key? key,
    required dynamic Function() onAuthSuccess,
    List<_i10.PageRouteInfo>? children,
  }) : super(
          AuthRoute.name,
          args: AuthRouteArgs(
            key: key,
            onAuthSuccess: onAuthSuccess,
          ),
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static const _i10.PageInfo<AuthRouteArgs> page =
      _i10.PageInfo<AuthRouteArgs>(name);
}

class AuthRouteArgs {
  const AuthRouteArgs({
    this.key,
    required this.onAuthSuccess,
  });

  final _i11.Key? key;

  final dynamic Function() onAuthSuccess;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key, onAuthSuccess: $onAuthSuccess}';
  }
}

/// generated route for
/// [_i2.EventDetailsScreen]
class EventDetailsRoute extends _i10.PageRouteInfo<EventDetailsRouteArgs> {
  EventDetailsRoute({
    _i11.Key? key,
    required int eventId,
    required _i12.EventImage eventImage,
    List<_i10.PageRouteInfo>? children,
  }) : super(
          EventDetailsRoute.name,
          args: EventDetailsRouteArgs(
            key: key,
            eventId: eventId,
            eventImage: eventImage,
          ),
          initialChildren: children,
        );

  static const String name = 'EventDetailsRoute';

  static const _i10.PageInfo<EventDetailsRouteArgs> page =
      _i10.PageInfo<EventDetailsRouteArgs>(name);
}

class EventDetailsRouteArgs {
  const EventDetailsRouteArgs({
    this.key,
    required this.eventId,
    required this.eventImage,
  });

  final _i11.Key? key;

  final int eventId;

  final _i12.EventImage eventImage;

  @override
  String toString() {
    return 'EventDetailsRouteArgs{key: $key, eventId: $eventId, eventImage: $eventImage}';
  }
}

/// generated route for
/// [_i3.EventsScreen]
class EventsRoute extends _i10.PageRouteInfo<void> {
  const EventsRoute({List<_i10.PageRouteInfo>? children})
      : super(
          EventsRoute.name,
          initialChildren: children,
        );

  static const String name = 'EventsRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ForgotPasswordRoute]
class ForgotPasswordRoute extends _i10.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i10.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i5.HudRoute]
class HudRoute extends _i10.PageRouteInfo<void> {
  const HudRoute({List<_i10.PageRouteInfo>? children})
      : super(
          HudRoute.name,
          initialChildren: children,
        );

  static const String name = 'HudRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i6.LoadingRoute]
class LoadingRoute extends _i10.PageRouteInfo<void> {
  const LoadingRoute({List<_i10.PageRouteInfo>? children})
      : super(
          LoadingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoadingRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i7.LoginRoute]
class LoginRoute extends _i10.PageRouteInfo<void> {
  const LoginRoute({List<_i10.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i8.NotificationRoute]
class NotificationRoute extends _i10.PageRouteInfo<void> {
  const NotificationRoute({List<_i10.PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i9.SignupRoute]
class SignupRoute extends _i10.PageRouteInfo<void> {
  const SignupRoute({List<_i10.PageRouteInfo>? children})
      : super(
          SignupRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignupRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}
