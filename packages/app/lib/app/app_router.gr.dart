// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;
import 'package:hollybike/auth/screens/login_screen.dart' as _i6;
import 'package:hollybike/auth/screens/signup_screen.dart' as _i11;
import 'package:hollybike/event/screens/event_candidates_screen.dart' as _i1;
import 'package:hollybike/event/screens/event_details_screen.dart' as _i2;
import 'package:hollybike/event/screens/event_participations_screen.dart'
    as _i3;
import 'package:hollybike/event/screens/events_screen.dart' as _i4;
import 'package:hollybike/event/screens/my_events_screen.dart' as _i8;
import 'package:hollybike/event/types/event_details.dart' as _i15;
import 'package:hollybike/event/types/event_participation.dart' as _i16;
import 'package:hollybike/event/widgets/event_image.dart' as _i14;
import 'package:hollybike/notification/routes/notification_route.dart' as _i9;
import 'package:hollybike/profile/screens/me_screen.dart' as _i7;
import 'package:hollybike/profile/screens/profile_screen.dart' as _i10;
import 'package:hollybike/shared/routes/loading_route.dart' as _i5;

abstract class $AppRouter extends _i12.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i12.PageFactory> pagesMap = {
    EventCandidatesRoute.name: (routeData) {
      final args = routeData.argsAs<EventCandidatesRouteArgs>();
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.EventCandidatesScreen(
          key: args.key,
          eventId: args.eventId,
        ),
      );
    },
    EventDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<EventDetailsRouteArgs>();
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.EventDetailsScreen(
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
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.EventParticipationsScreen(
          key: args.key,
          eventDetails: args.eventDetails,
          participationPreview: args.participationPreview,
        ),
      );
    },
    EventsRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.EventsScreen(),
      );
    },
    LoadingRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.LoadingRoute(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.LoginScreen(
          key: args.key,
          onAuthSuccess: args.onAuthSuccess,
          canPop: args.canPop,
        ),
      );
    },
    MeRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.MeScreen(),
      );
    },
    MyEventsRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.MyEventsScreen(),
      );
    },
    NotificationRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.NotificationRoute(),
      );
    },
    ProfileRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProfileRouteArgs>(
          orElse: () => ProfileRouteArgs(id: pathParams.optString('id')));
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.ProfileScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    SignupRoute.name: (routeData) {
      final args = routeData.argsAs<SignupRouteArgs>(
          orElse: () => const SignupRouteArgs());
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.SignupScreen(
          key: args.key,
          onAuthSuccess: args.onAuthSuccess,
          canPop: args.canPop,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.EventCandidatesScreen]
class EventCandidatesRoute
    extends _i12.PageRouteInfo<EventCandidatesRouteArgs> {
  EventCandidatesRoute({
    _i13.Key? key,
    required int eventId,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          EventCandidatesRoute.name,
          args: EventCandidatesRouteArgs(
            key: key,
            eventId: eventId,
          ),
          initialChildren: children,
        );

  static const String name = 'EventCandidatesRoute';

  static const _i12.PageInfo<EventCandidatesRouteArgs> page =
      _i12.PageInfo<EventCandidatesRouteArgs>(name);
}

class EventCandidatesRouteArgs {
  const EventCandidatesRouteArgs({
    this.key,
    required this.eventId,
  });

  final _i13.Key? key;

  final int eventId;

  @override
  String toString() {
    return 'EventCandidatesRouteArgs{key: $key, eventId: $eventId}';
  }
}

/// generated route for
/// [_i2.EventDetailsScreen]
class EventDetailsRoute extends _i12.PageRouteInfo<EventDetailsRouteArgs> {
  EventDetailsRoute({
    _i13.Key? key,
    required int eventId,
    required _i14.EventImage eventImage,
    required String eventName,
    bool animate = true,
    List<_i12.PageRouteInfo>? children,
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

  static const _i12.PageInfo<EventDetailsRouteArgs> page =
      _i12.PageInfo<EventDetailsRouteArgs>(name);
}

class EventDetailsRouteArgs {
  const EventDetailsRouteArgs({
    this.key,
    required this.eventId,
    required this.eventImage,
    required this.eventName,
    this.animate = true,
  });

  final _i13.Key? key;

  final int eventId;

  final _i14.EventImage eventImage;

  final String eventName;

  final bool animate;

  @override
  String toString() {
    return 'EventDetailsRouteArgs{key: $key, eventId: $eventId, eventImage: $eventImage, eventName: $eventName, animate: $animate}';
  }
}

/// generated route for
/// [_i3.EventParticipationsScreen]
class EventParticipationsRoute
    extends _i12.PageRouteInfo<EventParticipationsRouteArgs> {
  EventParticipationsRoute({
    _i13.Key? key,
    required _i15.EventDetails eventDetails,
    required List<_i16.EventParticipation> participationPreview,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          EventParticipationsRoute.name,
          args: EventParticipationsRouteArgs(
            key: key,
            eventDetails: eventDetails,
            participationPreview: participationPreview,
          ),
          initialChildren: children,
        );

  static const String name = 'EventParticipationsRoute';

  static const _i12.PageInfo<EventParticipationsRouteArgs> page =
      _i12.PageInfo<EventParticipationsRouteArgs>(name);
}

class EventParticipationsRouteArgs {
  const EventParticipationsRouteArgs({
    this.key,
    required this.eventDetails,
    required this.participationPreview,
  });

  final _i13.Key? key;

  final _i15.EventDetails eventDetails;

  final List<_i16.EventParticipation> participationPreview;

  @override
  String toString() {
    return 'EventParticipationsRouteArgs{key: $key, eventDetails: $eventDetails, participationPreview: $participationPreview}';
  }
}

/// generated route for
/// [_i4.EventsScreen]
class EventsRoute extends _i12.PageRouteInfo<void> {
  const EventsRoute({List<_i12.PageRouteInfo>? children})
      : super(
          EventsRoute.name,
          initialChildren: children,
        );

  static const String name = 'EventsRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i5.LoadingRoute]
class LoadingRoute extends _i12.PageRouteInfo<void> {
  const LoadingRoute({List<_i12.PageRouteInfo>? children})
      : super(
          LoadingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoadingRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i6.LoginScreen]
class LoginRoute extends _i12.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i13.Key? key,
    required dynamic Function() onAuthSuccess,
    bool canPop = false,
    List<_i12.PageRouteInfo>? children,
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

  static const _i12.PageInfo<LoginRouteArgs> page =
      _i12.PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    required this.onAuthSuccess,
    this.canPop = false,
  });

  final _i13.Key? key;

  final dynamic Function() onAuthSuccess;

  final bool canPop;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onAuthSuccess: $onAuthSuccess, canPop: $canPop}';
  }
}

/// generated route for
/// [_i7.MeScreen]
class MeRoute extends _i12.PageRouteInfo<void> {
  const MeRoute({List<_i12.PageRouteInfo>? children})
      : super(
          MeRoute.name,
          initialChildren: children,
        );

  static const String name = 'MeRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i8.MyEventsScreen]
class MyEventsRoute extends _i12.PageRouteInfo<void> {
  const MyEventsRoute({List<_i12.PageRouteInfo>? children})
      : super(
          MyEventsRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyEventsRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i9.NotificationRoute]
class NotificationRoute extends _i12.PageRouteInfo<void> {
  const NotificationRoute({List<_i12.PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i10.ProfileScreen]
class ProfileRoute extends _i12.PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    _i13.Key? key,
    String? id,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          ProfileRoute.name,
          args: ProfileRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i12.PageInfo<ProfileRouteArgs> page =
      _i12.PageInfo<ProfileRouteArgs>(name);
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    this.key,
    this.id,
  });

  final _i13.Key? key;

  final String? id;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i11.SignupScreen]
class SignupRoute extends _i12.PageRouteInfo<SignupRouteArgs> {
  SignupRoute({
    _i13.Key? key,
    dynamic Function()? onAuthSuccess,
    bool canPop = false,
    List<_i12.PageRouteInfo>? children,
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

  static const _i12.PageInfo<SignupRouteArgs> page =
      _i12.PageInfo<SignupRouteArgs>(name);
}

class SignupRouteArgs {
  const SignupRouteArgs({
    this.key,
    this.onAuthSuccess,
    this.canPop = false,
  });

  final _i13.Key? key;

  final dynamic Function()? onAuthSuccess;

  final bool canPop;

  @override
  String toString() {
    return 'SignupRouteArgs{key: $key, onAuthSuccess: $onAuthSuccess, canPop: $canPop}';
  }
}
