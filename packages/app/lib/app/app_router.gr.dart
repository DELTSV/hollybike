// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;
import 'package:hollybike/auth/screens/login_screen.dart' as _i5;
import 'package:hollybike/event/screens/event_details_screen.dart' as _i1;
import 'package:hollybike/event/screens/events_screen.dart' as _i2;
import 'package:hollybike/event/widgets/event_image.dart' as _i9;
import 'package:hollybike/hud/routes/hud_route.dart' as _i3;
import 'package:hollybike/notification/routes/notification_route.dart' as _i6;
import 'package:hollybike/shared/routes/loading_route.dart' as _i4;

abstract class $AppRouter extends _i7.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    EventDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<EventDetailsRouteArgs>();
      return _i7.AutoRoutePage<dynamic>(
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
    EventsRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.EventsScreen(),
      );
    },
    HudRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.HudRoute(),
      );
    },
    LoadingRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.LoadingRoute(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.LoginScreen(
          key: args.key,
          onAuthSuccess: args.onAuthSuccess,
        ),
      );
    },
    NotificationRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.NotificationRoute(),
      );
    },
  };
}

/// generated route for
/// [_i1.EventDetailsScreen]
class EventDetailsRoute extends _i7.PageRouteInfo<EventDetailsRouteArgs> {
  EventDetailsRoute({
    _i8.Key? key,
    required int eventId,
    required _i9.EventImage eventImage,
    required String eventName,
    bool animate = true,
    List<_i7.PageRouteInfo>? children,
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

  static const _i7.PageInfo<EventDetailsRouteArgs> page =
      _i7.PageInfo<EventDetailsRouteArgs>(name);
}

class EventDetailsRouteArgs {
  const EventDetailsRouteArgs({
    this.key,
    required this.eventId,
    required this.eventImage,
    required this.eventName,
    this.animate = true,
  });

  final _i8.Key? key;

  final int eventId;

  final _i9.EventImage eventImage;

  final String eventName;

  final bool animate;

  @override
  String toString() {
    return 'EventDetailsRouteArgs{key: $key, eventId: $eventId, eventImage: $eventImage, eventName: $eventName, animate: $animate}';
  }
}

/// generated route for
/// [_i2.EventsScreen]
class EventsRoute extends _i7.PageRouteInfo<void> {
  const EventsRoute({List<_i7.PageRouteInfo>? children})
      : super(
          EventsRoute.name,
          initialChildren: children,
        );

  static const String name = 'EventsRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i3.HudRoute]
class HudRoute extends _i7.PageRouteInfo<void> {
  const HudRoute({List<_i7.PageRouteInfo>? children})
      : super(
          HudRoute.name,
          initialChildren: children,
        );

  static const String name = 'HudRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i4.LoadingRoute]
class LoadingRoute extends _i7.PageRouteInfo<void> {
  const LoadingRoute({List<_i7.PageRouteInfo>? children})
      : super(
          LoadingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoadingRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i5.LoginScreen]
class LoginRoute extends _i7.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i8.Key? key,
    required dynamic Function() onAuthSuccess,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onAuthSuccess: onAuthSuccess,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i7.PageInfo<LoginRouteArgs> page =
      _i7.PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    required this.onAuthSuccess,
  });

  final _i8.Key? key;

  final dynamic Function() onAuthSuccess;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onAuthSuccess: $onAuthSuccess}';
  }
}

/// generated route for
/// [_i6.NotificationRoute]
class NotificationRoute extends _i7.PageRouteInfo<void> {
  const NotificationRoute({List<_i7.PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}
