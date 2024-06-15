// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i14;
import 'package:flutter/material.dart' as _i15;
import 'package:hollybike/auth/screens/login_screen.dart' as _i8;
import 'package:hollybike/auth/screens/signup_screen.dart' as _i13;
import 'package:hollybike/event/screens/event_details_screen.dart' as _i2;
import 'package:hollybike/event/screens/events_screen.dart' as _i6;
import 'package:hollybike/event/screens/image/event_image_view_screen.dart'
    as _i3;
import 'package:hollybike/event/screens/image/event_my_image_view_screen.dart'
    as _i4;
import 'package:hollybike/event/screens/my_events_screen.dart' as _i10;
import 'package:hollybike/event/screens/participations/event_candidates_screen.dart'
    as _i1;
import 'package:hollybike/event/screens/participations/event_participations_screen.dart'
    as _i5;
import 'package:hollybike/event/types/event_details.dart' as _i17;
import 'package:hollybike/event/types/minimal_event.dart' as _i16;
import 'package:hollybike/event/types/participation/event_participation.dart'
    as _i18;
import 'package:hollybike/notification/routes/notification_route.dart' as _i11;
import 'package:hollybike/profile/screens/me_screen.dart' as _i9;
import 'package:hollybike/profile/screens/profile_screen.dart' as _i12;
import 'package:hollybike/shared/routes/loading_route.dart' as _i7;

abstract class $AppRouter extends _i14.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i14.PageFactory> pagesMap = {
    EventCandidatesRoute.name: (routeData) {
      final args = routeData.argsAs<EventCandidatesRouteArgs>();
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.EventCandidatesScreen(
          key: args.key,
          eventId: args.eventId,
        ),
      );
    },
    EventDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<EventDetailsRouteArgs>();
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.EventDetailsScreen(
          key: args.key,
          event: args.event,
          animate: args.animate,
        ),
      );
    },
    EventImageViewRoute.name: (routeData) {
      final args = routeData.argsAs<EventImageViewRouteArgs>();
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.EventImageViewScreen(
          key: args.key,
          imageIndex: args.imageIndex,
          onLoadNextPage: args.onLoadNextPage,
        ),
      );
    },
    EventMyImageViewRoute.name: (routeData) {
      final args = routeData.argsAs<EventMyImageViewRouteArgs>();
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.EventMyImageViewScreen(
          key: args.key,
          imageIndex: args.imageIndex,
          onLoadNextPage: args.onLoadNextPage,
        ),
      );
    },
    EventParticipationsRoute.name: (routeData) {
      final args = routeData.argsAs<EventParticipationsRouteArgs>();
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.EventParticipationsScreen(
          key: args.key,
          eventDetails: args.eventDetails,
          participationPreview: args.participationPreview,
        ),
      );
    },
    EventsRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.EventsScreen(),
      );
    },
    LoadingRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.LoadingRoute(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.LoginScreen(
          key: args.key,
          onAuthSuccess: args.onAuthSuccess,
          canPop: args.canPop,
        ),
      );
    },
    MeRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.MeScreen(),
      );
    },
    MyEventsRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.MyEventsScreen(),
      );
    },
    NotificationRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.NotificationRoute(),
      );
    },
    ProfileRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProfileRouteArgs>(
          orElse: () => ProfileRouteArgs(id: pathParams.optString('id')));
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.ProfileScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    SignupRoute.name: (routeData) {
      final args = routeData.argsAs<SignupRouteArgs>(
          orElse: () => const SignupRouteArgs());
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.SignupScreen(
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
    extends _i14.PageRouteInfo<EventCandidatesRouteArgs> {
  EventCandidatesRoute({
    _i15.Key? key,
    required int eventId,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          EventCandidatesRoute.name,
          args: EventCandidatesRouteArgs(
            key: key,
            eventId: eventId,
          ),
          initialChildren: children,
        );

  static const String name = 'EventCandidatesRoute';

  static const _i14.PageInfo<EventCandidatesRouteArgs> page =
      _i14.PageInfo<EventCandidatesRouteArgs>(name);
}

class EventCandidatesRouteArgs {
  const EventCandidatesRouteArgs({
    this.key,
    required this.eventId,
  });

  final _i15.Key? key;

  final int eventId;

  @override
  String toString() {
    return 'EventCandidatesRouteArgs{key: $key, eventId: $eventId}';
  }
}

/// generated route for
/// [_i2.EventDetailsScreen]
class EventDetailsRoute extends _i14.PageRouteInfo<EventDetailsRouteArgs> {
  EventDetailsRoute({
    _i15.Key? key,
    required _i16.MinimalEvent event,
    bool animate = true,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          EventDetailsRoute.name,
          args: EventDetailsRouteArgs(
            key: key,
            event: event,
            animate: animate,
          ),
          initialChildren: children,
        );

  static const String name = 'EventDetailsRoute';

  static const _i14.PageInfo<EventDetailsRouteArgs> page =
      _i14.PageInfo<EventDetailsRouteArgs>(name);
}

class EventDetailsRouteArgs {
  const EventDetailsRouteArgs({
    this.key,
    required this.event,
    this.animate = true,
  });

  final _i15.Key? key;

  final _i16.MinimalEvent event;

  final bool animate;

  @override
  String toString() {
    return 'EventDetailsRouteArgs{key: $key, event: $event, animate: $animate}';
  }
}

/// generated route for
/// [_i3.EventImageViewScreen]
class EventImageViewRoute extends _i14.PageRouteInfo<EventImageViewRouteArgs> {
  EventImageViewRoute({
    _i15.Key? key,
    required int imageIndex,
    required void Function() onLoadNextPage,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          EventImageViewRoute.name,
          args: EventImageViewRouteArgs(
            key: key,
            imageIndex: imageIndex,
            onLoadNextPage: onLoadNextPage,
          ),
          initialChildren: children,
        );

  static const String name = 'EventImageViewRoute';

  static const _i14.PageInfo<EventImageViewRouteArgs> page =
      _i14.PageInfo<EventImageViewRouteArgs>(name);
}

class EventImageViewRouteArgs {
  const EventImageViewRouteArgs({
    this.key,
    required this.imageIndex,
    required this.onLoadNextPage,
  });

  final _i15.Key? key;

  final int imageIndex;

  final void Function() onLoadNextPage;

  @override
  String toString() {
    return 'EventImageViewRouteArgs{key: $key, imageIndex: $imageIndex, onLoadNextPage: $onLoadNextPage}';
  }
}

/// generated route for
/// [_i4.EventMyImageViewScreen]
class EventMyImageViewRoute
    extends _i14.PageRouteInfo<EventMyImageViewRouteArgs> {
  EventMyImageViewRoute({
    _i15.Key? key,
    required int imageIndex,
    required void Function() onLoadNextPage,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          EventMyImageViewRoute.name,
          args: EventMyImageViewRouteArgs(
            key: key,
            imageIndex: imageIndex,
            onLoadNextPage: onLoadNextPage,
          ),
          initialChildren: children,
        );

  static const String name = 'EventMyImageViewRoute';

  static const _i14.PageInfo<EventMyImageViewRouteArgs> page =
      _i14.PageInfo<EventMyImageViewRouteArgs>(name);
}

class EventMyImageViewRouteArgs {
  const EventMyImageViewRouteArgs({
    this.key,
    required this.imageIndex,
    required this.onLoadNextPage,
  });

  final _i15.Key? key;

  final int imageIndex;

  final void Function() onLoadNextPage;

  @override
  String toString() {
    return 'EventMyImageViewRouteArgs{key: $key, imageIndex: $imageIndex, onLoadNextPage: $onLoadNextPage}';
  }
}

/// generated route for
/// [_i5.EventParticipationsScreen]
class EventParticipationsRoute
    extends _i14.PageRouteInfo<EventParticipationsRouteArgs> {
  EventParticipationsRoute({
    _i15.Key? key,
    required _i17.EventDetails eventDetails,
    required List<_i18.EventParticipation> participationPreview,
    List<_i14.PageRouteInfo>? children,
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

  static const _i14.PageInfo<EventParticipationsRouteArgs> page =
      _i14.PageInfo<EventParticipationsRouteArgs>(name);
}

class EventParticipationsRouteArgs {
  const EventParticipationsRouteArgs({
    this.key,
    required this.eventDetails,
    required this.participationPreview,
  });

  final _i15.Key? key;

  final _i17.EventDetails eventDetails;

  final List<_i18.EventParticipation> participationPreview;

  @override
  String toString() {
    return 'EventParticipationsRouteArgs{key: $key, eventDetails: $eventDetails, participationPreview: $participationPreview}';
  }
}

/// generated route for
/// [_i6.EventsScreen]
class EventsRoute extends _i14.PageRouteInfo<void> {
  const EventsRoute({List<_i14.PageRouteInfo>? children})
      : super(
          EventsRoute.name,
          initialChildren: children,
        );

  static const String name = 'EventsRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i7.LoadingRoute]
class LoadingRoute extends _i14.PageRouteInfo<void> {
  const LoadingRoute({List<_i14.PageRouteInfo>? children})
      : super(
          LoadingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoadingRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i8.LoginScreen]
class LoginRoute extends _i14.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i15.Key? key,
    required dynamic Function() onAuthSuccess,
    bool canPop = false,
    List<_i14.PageRouteInfo>? children,
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

  static const _i14.PageInfo<LoginRouteArgs> page =
      _i14.PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    required this.onAuthSuccess,
    this.canPop = false,
  });

  final _i15.Key? key;

  final dynamic Function() onAuthSuccess;

  final bool canPop;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onAuthSuccess: $onAuthSuccess, canPop: $canPop}';
  }
}

/// generated route for
/// [_i9.MeScreen]
class MeRoute extends _i14.PageRouteInfo<void> {
  const MeRoute({List<_i14.PageRouteInfo>? children})
      : super(
          MeRoute.name,
          initialChildren: children,
        );

  static const String name = 'MeRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i10.MyEventsScreen]
class MyEventsRoute extends _i14.PageRouteInfo<void> {
  const MyEventsRoute({List<_i14.PageRouteInfo>? children})
      : super(
          MyEventsRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyEventsRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i11.NotificationRoute]
class NotificationRoute extends _i14.PageRouteInfo<void> {
  const NotificationRoute({List<_i14.PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i12.ProfileScreen]
class ProfileRoute extends _i14.PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    _i15.Key? key,
    String? id,
    List<_i14.PageRouteInfo>? children,
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

  static const _i14.PageInfo<ProfileRouteArgs> page =
      _i14.PageInfo<ProfileRouteArgs>(name);
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    this.key,
    this.id,
  });

  final _i15.Key? key;

  final String? id;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i13.SignupScreen]
class SignupRoute extends _i14.PageRouteInfo<SignupRouteArgs> {
  SignupRoute({
    _i15.Key? key,
    dynamic Function()? onAuthSuccess,
    bool canPop = false,
    List<_i14.PageRouteInfo>? children,
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

  static const _i14.PageInfo<SignupRouteArgs> page =
      _i14.PageInfo<SignupRouteArgs>(name);
}

class SignupRouteArgs {
  const SignupRouteArgs({
    this.key,
    this.onAuthSuccess,
    this.canPop = false,
  });

  final _i15.Key? key;

  final dynamic Function()? onAuthSuccess;

  final bool canPop;

  @override
  String toString() {
    return 'SignupRouteArgs{key: $key, onAuthSuccess: $onAuthSuccess, canPop: $canPop}';
  }
}
