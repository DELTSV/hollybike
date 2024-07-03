// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i15;
import 'package:flutter/material.dart' as _i16;
import 'package:hollybike/auth/screens/login_screen.dart' as _i8;
import 'package:hollybike/auth/screens/signup_screen.dart' as _i14;
import 'package:hollybike/event/screens/event_details_screen.dart' as _i2;
import 'package:hollybike/event/screens/events_screen.dart' as _i6;
import 'package:hollybike/event/screens/image/event_image_view_screen.dart'
    as _i3;
import 'package:hollybike/event/screens/image/event_my_image_view_screen.dart'
    as _i4;
import 'package:hollybike/event/screens/participations/event_candidates_screen.dart'
    as _i1;
import 'package:hollybike/event/screens/participations/event_participations_screen.dart'
    as _i5;
import 'package:hollybike/event/types/event_details.dart' as _i18;
import 'package:hollybike/event/types/minimal_event.dart' as _i17;
import 'package:hollybike/event/types/participation/event_participation.dart'
    as _i19;
import 'package:hollybike/notification/routes/notification_route.dart' as _i10;
import 'package:hollybike/profile/screens/me_screen.dart' as _i9;
import 'package:hollybike/profile/screens/profile_image_view_screen.dart'
    as _i11;
import 'package:hollybike/profile/screens/profile_screen.dart' as _i12;
import 'package:hollybike/search/screens/search_screen.dart' as _i13;
import 'package:hollybike/shared/routes/loading_route.dart' as _i7;

abstract class $AppRouter extends _i15.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i15.PageFactory> pagesMap = {
    EventCandidatesRoute.name: (routeData) {
      final args = routeData.argsAs<EventCandidatesRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.WrappedRoute(
            child: _i1.EventCandidatesScreen(
          key: args.key,
          eventId: args.eventId,
        )),
      );
    },
    EventDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<EventDetailsRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.WrappedRoute(
            child: _i2.EventDetailsScreen(
          key: args.key,
          event: args.event,
          animate: args.animate,
        )),
      );
    },
    EventImageViewRoute.name: (routeData) {
      final args = routeData.argsAs<EventImageViewRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.WrappedRoute(
            child: _i3.EventImageViewScreen(
          key: args.key,
          imageIndex: args.imageIndex,
          onLoadNextPage: args.onLoadNextPage,
          onRefresh: args.onRefresh,
        )),
      );
    },
    EventMyImageViewRoute.name: (routeData) {
      final args = routeData.argsAs<EventMyImageViewRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.WrappedRoute(
            child: _i4.EventMyImageViewScreen(
          key: args.key,
          imageIndex: args.imageIndex,
          onLoadNextPage: args.onLoadNextPage,
          onRefresh: args.onRefresh,
        )),
      );
    },
    EventParticipationsRoute.name: (routeData) {
      final args = routeData.argsAs<EventParticipationsRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.WrappedRoute(
            child: _i5.EventParticipationsScreen(
          key: args.key,
          eventDetails: args.eventDetails,
          participationPreview: args.participationPreview,
        )),
      );
    },
    EventsRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.WrappedRoute(child: const _i6.EventsScreen()),
      );
    },
    LoadingRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.LoadingRoute(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.LoginScreen(
          key: args.key,
          onAuthSuccess: args.onAuthSuccess,
          canPop: args.canPop,
        ),
      );
    },
    MeRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.MeScreen(),
      );
    },
    NotificationRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.NotificationRoute(),
      );
    },
    ProfileImageViewRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileImageViewRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.WrappedRoute(
            child: _i11.ProfileImageViewScreen(
          key: args.key,
          imageIndex: args.imageIndex,
          onLoadNextPage: args.onLoadNextPage,
          onRefresh: args.onRefresh,
        )),
      );
    },
    ProfileRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProfileRouteArgs>(
          orElse: () => ProfileRouteArgs(id: pathParams.optString('id')));
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.ProfileScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    SearchRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.SearchScreen(),
      );
    },
    SignupRoute.name: (routeData) {
      final args = routeData.argsAs<SignupRouteArgs>(
          orElse: () => const SignupRouteArgs());
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.SignupScreen(
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
    extends _i15.PageRouteInfo<EventCandidatesRouteArgs> {
  EventCandidatesRoute({
    _i16.Key? key,
    required int eventId,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          EventCandidatesRoute.name,
          args: EventCandidatesRouteArgs(
            key: key,
            eventId: eventId,
          ),
          initialChildren: children,
        );

  static const String name = 'EventCandidatesRoute';

  static const _i15.PageInfo<EventCandidatesRouteArgs> page =
      _i15.PageInfo<EventCandidatesRouteArgs>(name);
}

class EventCandidatesRouteArgs {
  const EventCandidatesRouteArgs({
    this.key,
    required this.eventId,
  });

  final _i16.Key? key;

  final int eventId;

  @override
  String toString() {
    return 'EventCandidatesRouteArgs{key: $key, eventId: $eventId}';
  }
}

/// generated route for
/// [_i2.EventDetailsScreen]
class EventDetailsRoute extends _i15.PageRouteInfo<EventDetailsRouteArgs> {
  EventDetailsRoute({
    _i16.Key? key,
    required _i17.MinimalEvent event,
    bool animate = true,
    List<_i15.PageRouteInfo>? children,
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

  static const _i15.PageInfo<EventDetailsRouteArgs> page =
      _i15.PageInfo<EventDetailsRouteArgs>(name);
}

class EventDetailsRouteArgs {
  const EventDetailsRouteArgs({
    this.key,
    required this.event,
    this.animate = true,
  });

  final _i16.Key? key;

  final _i17.MinimalEvent event;

  final bool animate;

  @override
  String toString() {
    return 'EventDetailsRouteArgs{key: $key, event: $event, animate: $animate}';
  }
}

/// generated route for
/// [_i3.EventImageViewScreen]
class EventImageViewRoute extends _i15.PageRouteInfo<EventImageViewRouteArgs> {
  EventImageViewRoute({
    _i16.Key? key,
    required int imageIndex,
    required void Function() onLoadNextPage,
    required void Function() onRefresh,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          EventImageViewRoute.name,
          args: EventImageViewRouteArgs(
            key: key,
            imageIndex: imageIndex,
            onLoadNextPage: onLoadNextPage,
            onRefresh: onRefresh,
          ),
          initialChildren: children,
        );

  static const String name = 'EventImageViewRoute';

  static const _i15.PageInfo<EventImageViewRouteArgs> page =
      _i15.PageInfo<EventImageViewRouteArgs>(name);
}

class EventImageViewRouteArgs {
  const EventImageViewRouteArgs({
    this.key,
    required this.imageIndex,
    required this.onLoadNextPage,
    required this.onRefresh,
  });

  final _i16.Key? key;

  final int imageIndex;

  final void Function() onLoadNextPage;

  final void Function() onRefresh;

  @override
  String toString() {
    return 'EventImageViewRouteArgs{key: $key, imageIndex: $imageIndex, onLoadNextPage: $onLoadNextPage, onRefresh: $onRefresh}';
  }
}

/// generated route for
/// [_i4.EventMyImageViewScreen]
class EventMyImageViewRoute
    extends _i15.PageRouteInfo<EventMyImageViewRouteArgs> {
  EventMyImageViewRoute({
    _i16.Key? key,
    required int imageIndex,
    required void Function() onLoadNextPage,
    required void Function() onRefresh,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          EventMyImageViewRoute.name,
          args: EventMyImageViewRouteArgs(
            key: key,
            imageIndex: imageIndex,
            onLoadNextPage: onLoadNextPage,
            onRefresh: onRefresh,
          ),
          initialChildren: children,
        );

  static const String name = 'EventMyImageViewRoute';

  static const _i15.PageInfo<EventMyImageViewRouteArgs> page =
      _i15.PageInfo<EventMyImageViewRouteArgs>(name);
}

class EventMyImageViewRouteArgs {
  const EventMyImageViewRouteArgs({
    this.key,
    required this.imageIndex,
    required this.onLoadNextPage,
    required this.onRefresh,
  });

  final _i16.Key? key;

  final int imageIndex;

  final void Function() onLoadNextPage;

  final void Function() onRefresh;

  @override
  String toString() {
    return 'EventMyImageViewRouteArgs{key: $key, imageIndex: $imageIndex, onLoadNextPage: $onLoadNextPage, onRefresh: $onRefresh}';
  }
}

/// generated route for
/// [_i5.EventParticipationsScreen]
class EventParticipationsRoute
    extends _i15.PageRouteInfo<EventParticipationsRouteArgs> {
  EventParticipationsRoute({
    _i16.Key? key,
    required _i18.EventDetails eventDetails,
    required List<_i19.EventParticipation> participationPreview,
    List<_i15.PageRouteInfo>? children,
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

  static const _i15.PageInfo<EventParticipationsRouteArgs> page =
      _i15.PageInfo<EventParticipationsRouteArgs>(name);
}

class EventParticipationsRouteArgs {
  const EventParticipationsRouteArgs({
    this.key,
    required this.eventDetails,
    required this.participationPreview,
  });

  final _i16.Key? key;

  final _i18.EventDetails eventDetails;

  final List<_i19.EventParticipation> participationPreview;

  @override
  String toString() {
    return 'EventParticipationsRouteArgs{key: $key, eventDetails: $eventDetails, participationPreview: $participationPreview}';
  }
}

/// generated route for
/// [_i6.EventsScreen]
class EventsRoute extends _i15.PageRouteInfo<void> {
  const EventsRoute({List<_i15.PageRouteInfo>? children})
      : super(
          EventsRoute.name,
          initialChildren: children,
        );

  static const String name = 'EventsRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i7.LoadingRoute]
class LoadingRoute extends _i15.PageRouteInfo<void> {
  const LoadingRoute({List<_i15.PageRouteInfo>? children})
      : super(
          LoadingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoadingRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i8.LoginScreen]
class LoginRoute extends _i15.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i16.Key? key,
    required dynamic Function() onAuthSuccess,
    bool canPop = false,
    List<_i15.PageRouteInfo>? children,
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

  static const _i15.PageInfo<LoginRouteArgs> page =
      _i15.PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    required this.onAuthSuccess,
    this.canPop = false,
  });

  final _i16.Key? key;

  final dynamic Function() onAuthSuccess;

  final bool canPop;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onAuthSuccess: $onAuthSuccess, canPop: $canPop}';
  }
}

/// generated route for
/// [_i9.MeScreen]
class MeRoute extends _i15.PageRouteInfo<void> {
  const MeRoute({List<_i15.PageRouteInfo>? children})
      : super(
          MeRoute.name,
          initialChildren: children,
        );

  static const String name = 'MeRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i10.NotificationRoute]
class NotificationRoute extends _i15.PageRouteInfo<void> {
  const NotificationRoute({List<_i15.PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i11.ProfileImageViewScreen]
class ProfileImageViewRoute
    extends _i15.PageRouteInfo<ProfileImageViewRouteArgs> {
  ProfileImageViewRoute({
    _i16.Key? key,
    required int imageIndex,
    required void Function() onLoadNextPage,
    required void Function() onRefresh,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          ProfileImageViewRoute.name,
          args: ProfileImageViewRouteArgs(
            key: key,
            imageIndex: imageIndex,
            onLoadNextPage: onLoadNextPage,
            onRefresh: onRefresh,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileImageViewRoute';

  static const _i15.PageInfo<ProfileImageViewRouteArgs> page =
      _i15.PageInfo<ProfileImageViewRouteArgs>(name);
}

class ProfileImageViewRouteArgs {
  const ProfileImageViewRouteArgs({
    this.key,
    required this.imageIndex,
    required this.onLoadNextPage,
    required this.onRefresh,
  });

  final _i16.Key? key;

  final int imageIndex;

  final void Function() onLoadNextPage;

  final void Function() onRefresh;

  @override
  String toString() {
    return 'ProfileImageViewRouteArgs{key: $key, imageIndex: $imageIndex, onLoadNextPage: $onLoadNextPage, onRefresh: $onRefresh}';
  }
}

/// generated route for
/// [_i12.ProfileScreen]
class ProfileRoute extends _i15.PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    _i16.Key? key,
    String? id,
    List<_i15.PageRouteInfo>? children,
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

  static const _i15.PageInfo<ProfileRouteArgs> page =
      _i15.PageInfo<ProfileRouteArgs>(name);
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    this.key,
    this.id,
  });

  final _i16.Key? key;

  final String? id;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i13.SearchScreen]
class SearchRoute extends _i15.PageRouteInfo<void> {
  const SearchRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i14.SignupScreen]
class SignupRoute extends _i15.PageRouteInfo<SignupRouteArgs> {
  SignupRoute({
    _i16.Key? key,
    dynamic Function()? onAuthSuccess,
    bool canPop = false,
    List<_i15.PageRouteInfo>? children,
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

  static const _i15.PageInfo<SignupRouteArgs> page =
      _i15.PageInfo<SignupRouteArgs>(name);
}

class SignupRouteArgs {
  const SignupRouteArgs({
    this.key,
    this.onAuthSuccess,
    this.canPop = false,
  });

  final _i16.Key? key;

  final dynamic Function()? onAuthSuccess;

  final bool canPop;

  @override
  String toString() {
    return 'SignupRouteArgs{key: $key, onAuthSuccess: $onAuthSuccess, canPop: $canPop}';
  }
}
