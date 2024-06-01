// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:hollybike/auth/screens/login_screen.dart' as _i6;
import 'package:hollybike/auth/screens/signup_screen.dart' as _i8;
import 'package:hollybike/event/screens/event_details_screen.dart' as _i1;
import 'package:hollybike/event/screens/event_participations_screen.dart'
    as _i2;
import 'package:hollybike/event/screens/events_screen.dart' as _i3;
import 'package:hollybike/event/widgets/event_image.dart' as _i11;
import 'package:hollybike/hud/routes/hud_route.dart' as _i4;
import 'package:hollybike/notification/routes/notification_route.dart' as _i7;
import 'package:hollybike/shared/routes/loading_route.dart' as _i5;

abstract class $AppRouter extends _i9.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    EventDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<EventDetailsRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.EventDetailsScreen(
          key: args.key,
          eventId: args.eventId,
          eventImage: args.eventImage,
          eventName: args.eventName,
          animate: args.animate,
        ),
      );
    },
    EventParticipationsRoute.name: (routeData) {
      final args = routeData.argsAs<EventParticipationsRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.EventParticipationsScreen(
          key: args.key,
          eventId: args.eventId,
        ),
      );
    },
    EventsRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.EventsScreen(),
      );
    },
    HudRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.HudRoute(),
      );
    },
    LoadingRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.LoadingRoute(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.LoginScreen(
          key: args.key,
          onAuthSuccess: args.onAuthSuccess,
          canPop: args.canPop,
        ),
      );
    },
    NotificationRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.NotificationRoute(),
      );
    },
    SignupRoute.name: (routeData) {
      final args = routeData.argsAs<SignupRouteArgs>(
          orElse: () => const SignupRouteArgs());
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.SignupScreen(
          key: args.key,
          onAuthSuccess: args.onAuthSuccess,
          canPop: args.canPop,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.EventDetailsScreen]
class EventDetailsRoute extends _i9.PageRouteInfo<EventDetailsRouteArgs> {
  EventDetailsRoute({
    _i10.Key? key,
    required int eventId,
    required _i11.EventImage eventImage,
    required String eventName,
    bool animate = true,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          EventDetailsRoute.name,
          args: EventDetailsRouteArgs(
            key: key,
            eventId: eventId,
            eventImage: eventImage,
            eventName: eventName,
            animate: animate,
          ),
          initialChildren: children,
        );

  static const String name = 'EventDetailsRoute';

  static const _i9.PageInfo<EventDetailsRouteArgs> page =
      _i9.PageInfo<EventDetailsRouteArgs>(name);
}

class EventDetailsRouteArgs {
  const EventDetailsRouteArgs({
    this.key,
    required this.eventId,
    required this.eventImage,
    required this.eventName,
    this.animate = true,
  });

  final _i10.Key? key;

  final int eventId;

  final _i11.EventImage eventImage;

  final String eventName;

  final bool animate;

  @override
  String toString() {
    return 'EventDetailsRouteArgs{key: $key, eventId: $eventId, eventImage: $eventImage, eventName: $eventName, animate: $animate}';
  }
}

/// generated route for
/// [_i2.EventParticipationsScreen]
class EventParticipationsRoute
    extends _i9.PageRouteInfo<EventParticipationsRouteArgs> {
  EventParticipationsRoute({
    _i10.Key? key,
    required int eventId,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          EventParticipationsRoute.name,
          args: EventParticipationsRouteArgs(
            key: key,
            eventId: eventId,
          ),
          initialChildren: children,
        );

  static const String name = 'EventParticipationsRoute';

  static const _i9.PageInfo<EventParticipationsRouteArgs> page =
      _i9.PageInfo<EventParticipationsRouteArgs>(name);
}

class EventParticipationsRouteArgs {
  const EventParticipationsRouteArgs({
    this.key,
    required this.eventId,
  });

  final _i10.Key? key;

  final int eventId;

  @override
  String toString() {
    return 'EventParticipationsRouteArgs{key: $key, eventId: $eventId}';
  }
}

/// generated route for
/// [_i3.EventsScreen]
class EventsRoute extends _i9.PageRouteInfo<void> {
  const EventsRoute({List<_i9.PageRouteInfo>? children})
      : super(
          EventsRoute.name,
          initialChildren: children,
        );

  static const String name = 'EventsRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i4.HudRoute]
class HudRoute extends _i9.PageRouteInfo<void> {
  const HudRoute({List<_i9.PageRouteInfo>? children})
      : super(
          HudRoute.name,
          initialChildren: children,
        );

  static const String name = 'HudRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i5.LoadingRoute]
class LoadingRoute extends _i9.PageRouteInfo<void> {
  const LoadingRoute({List<_i9.PageRouteInfo>? children})
      : super(
          LoadingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoadingRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i6.LoginScreen]
class LoginRoute extends _i9.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i10.Key? key,
    required dynamic Function() onAuthSuccess,
    bool canPop = false,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onAuthSuccess: onAuthSuccess,
            canPop: canPop,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i9.PageInfo<LoginRouteArgs> page =
      _i9.PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    required this.onAuthSuccess,
    this.canPop = false,
  });

  final _i10.Key? key;

  final dynamic Function() onAuthSuccess;

  final bool canPop;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onAuthSuccess: $onAuthSuccess, canPop: $canPop}';
  }
}

/// generated route for
/// [_i7.NotificationRoute]
class NotificationRoute extends _i9.PageRouteInfo<void> {
  const NotificationRoute({List<_i9.PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i8.SignupScreen]
class SignupRoute extends _i9.PageRouteInfo<SignupRouteArgs> {
  SignupRoute({
    _i10.Key? key,
    dynamic Function()? onAuthSuccess,
    bool canPop = false,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          SignupRoute.name,
          args: SignupRouteArgs(
            key: key,
            onAuthSuccess: onAuthSuccess,
            canPop: canPop,
          ),
          initialChildren: children,
        );

  static const String name = 'SignupRoute';

  static const _i9.PageInfo<SignupRouteArgs> page =
      _i9.PageInfo<SignupRouteArgs>(name);
}

class SignupRouteArgs {
  const SignupRouteArgs({
    this.key,
    this.onAuthSuccess,
    this.canPop = false,
  });

  final _i10.Key? key;

  final dynamic Function()? onAuthSuccess;

  final bool canPop;

  @override
  String toString() {
    return 'SignupRouteArgs{key: $key, onAuthSuccess: $onAuthSuccess, canPop: $canPop}';
  }
}
