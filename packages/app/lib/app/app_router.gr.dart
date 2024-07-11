// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;
import 'package:hollybike/auth/screens/login_screen.dart' as _i7;
import 'package:hollybike/auth/screens/signup_screen.dart' as _i11;
import 'package:hollybike/event/screens/event_details_screen.dart' as _i2;
import 'package:hollybike/event/screens/events_screen.dart' as _i4;
import 'package:hollybike/event/screens/participations/event_candidates_screen.dart'
    as _i1;
import 'package:hollybike/event/screens/participations/event_participations_screen.dart'
    as _i3;
import 'package:hollybike/event/types/event_details.dart' as _i15;
import 'package:hollybike/event/types/minimal_event.dart' as _i14;
import 'package:hollybike/event/types/participation/event_participation.dart'
    as _i16;
import 'package:hollybike/image/bloc/image_list_bloc.dart' as _i17;
import 'package:hollybike/image/screens/image_gallery_page_view_screen.dart'
    as _i5;
import 'package:hollybike/profile/screens/me_screen.dart' as _i8;
import 'package:hollybike/profile/screens/profile_screen.dart' as _i9;
import 'package:hollybike/search/screens/search_screen.dart' as _i10;
import 'package:hollybike/shared/routes/loading_route.dart' as _i6;

abstract class $AppRouter extends _i12.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i12.PageFactory> pagesMap = {
    EventCandidatesRoute.name: (routeData) {
      final args = routeData.argsAs<EventCandidatesRouteArgs>();
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.WrappedRoute(
            child: _i1.EventCandidatesScreen(
          key: args.key,
          eventId: args.eventId,
        )),
      );
    },
    EventDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<EventDetailsRouteArgs>();
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.WrappedRoute(
            child: _i2.EventDetailsScreen(
          key: args.key,
          event: args.event,
          animate: args.animate,
          uniqueKey: args.uniqueKey,
        )),
      );
    },
    EventParticipationsRoute.name: (routeData) {
      final args = routeData.argsAs<EventParticipationsRouteArgs>();
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.WrappedRoute(
            child: _i3.EventParticipationsScreen(
          key: args.key,
          eventDetails: args.eventDetails,
          participationPreview: args.participationPreview,
        )),
      );
    },
    EventsRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.WrappedRoute(child: const _i4.EventsScreen()),
      );
    },
    ImageGalleryViewRoute.name: (routeData) {
      final args = routeData.argsAs<ImageGalleryViewRouteArgs>();
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.WrappedRoute(
            child: _i5.ImageGalleryViewScreen(
          key: args.key,
          imageIndex: args.imageIndex,
          onLoadNextPage: args.onLoadNextPage,
          onRefresh: args.onRefresh,
          bloc: args.bloc,
        )),
      );
    },
    LoadingRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.LoadingRoute(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.LoginScreen(
          key: args.key,
          onAuthSuccess: args.onAuthSuccess,
          canPop: args.canPop,
        ),
      );
    },
    MeRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.MeScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProfileRouteArgs>(
          orElse: () => ProfileRouteArgs(urlId: pathParams.optString('id')));
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.ProfileScreen(
          key: args.key,
          urlId: args.urlId,
        ),
      );
    },
    SearchRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.SearchScreen(),
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
    required _i14.MinimalEvent event,
    bool animate = true,
    String uniqueKey = "default",
    List<_i12.PageRouteInfo>? children,
  }) : super(
          EventDetailsRoute.name,
          args: EventDetailsRouteArgs(
            key: key,
            event: event,
            animate: animate,
            uniqueKey: uniqueKey,
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
    required this.event,
    this.animate = true,
    this.uniqueKey = "default",
  });

  final _i13.Key? key;

  final _i14.MinimalEvent event;

  final bool animate;

  final String uniqueKey;

  @override
  String toString() {
    return 'EventDetailsRouteArgs{key: $key, event: $event, animate: $animate, uniqueKey: $uniqueKey}';
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
/// [_i5.ImageGalleryViewScreen]
class ImageGalleryViewRoute
    extends _i12.PageRouteInfo<ImageGalleryViewRouteArgs> {
  ImageGalleryViewRoute({
    _i13.Key? key,
    required int imageIndex,
    required void Function() onLoadNextPage,
    required void Function() onRefresh,
    required _i17.ImageListBloc<dynamic> bloc,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          ImageGalleryViewRoute.name,
          args: ImageGalleryViewRouteArgs(
            key: key,
            imageIndex: imageIndex,
            onLoadNextPage: onLoadNextPage,
            onRefresh: onRefresh,
            bloc: bloc,
          ),
          initialChildren: children,
        );

  static const String name = 'ImageGalleryViewRoute';

  static const _i12.PageInfo<ImageGalleryViewRouteArgs> page =
      _i12.PageInfo<ImageGalleryViewRouteArgs>(name);
}

class ImageGalleryViewRouteArgs {
  const ImageGalleryViewRouteArgs({
    this.key,
    required this.imageIndex,
    required this.onLoadNextPage,
    required this.onRefresh,
    required this.bloc,
  });

  final _i13.Key? key;

  final int imageIndex;

  final void Function() onLoadNextPage;

  final void Function() onRefresh;

  final _i17.ImageListBloc<dynamic> bloc;

  @override
  String toString() {
    return 'ImageGalleryViewRouteArgs{key: $key, imageIndex: $imageIndex, onLoadNextPage: $onLoadNextPage, onRefresh: $onRefresh, bloc: $bloc}';
  }
}

/// generated route for
/// [_i6.LoadingRoute]
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
/// [_i7.LoginScreen]
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
/// [_i8.MeScreen]
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
/// [_i9.ProfileScreen]
class ProfileRoute extends _i12.PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    _i13.Key? key,
    String? urlId,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          ProfileRoute.name,
          args: ProfileRouteArgs(
            key: key,
            urlId: urlId,
          ),
          rawPathParams: {'id': urlId},
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i12.PageInfo<ProfileRouteArgs> page =
      _i12.PageInfo<ProfileRouteArgs>(name);
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    this.key,
    this.urlId,
  });

  final _i13.Key? key;

  final String? urlId;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, urlId: $urlId}';
  }
}

/// generated route for
/// [_i10.SearchScreen]
class SearchRoute extends _i12.PageRouteInfo<void> {
  const SearchRoute({List<_i12.PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
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
