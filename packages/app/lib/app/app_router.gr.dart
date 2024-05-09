// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;
import 'package:hollybike/auth/routes/auth_route.dart' as _i1;
import 'package:hollybike/auth/routes/forgot_password_route.dart' as _i2;
import 'package:hollybike/auth/routes/login_route.dart' as _i4;
import 'package:hollybike/auth/routes/signup_route.dart' as _i6;
import 'package:hollybike/hud/routes/hud_route.dart' as _i3;
import 'package:hollybike/notification/routes/notification_route.dart' as _i5;

abstract class $AppRouter extends _i7.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    AuthRoute.name: (routeData) {
      final args = routeData.argsAs<AuthRouteArgs>();
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AuthRoute(
          key: args.key,
          onAuthSuccess: args.onAuthSuccess,
        ),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ForgotPasswordRoute(),
      );
    },
    HudRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.HudRoute(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.LoginRoute(),
      );
    },
    NotificationRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.NotificationRoute(),
      );
    },
    SignupRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.SignupRoute(),
      );
    },
  };
}

/// generated route for
/// [_i1.AuthRoute]
class AuthRoute extends _i7.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({
    _i8.Key? key,
    required dynamic Function() onAuthSuccess,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          AuthRoute.name,
          args: AuthRouteArgs(
            key: key,
            onAuthSuccess: onAuthSuccess,
          ),
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static const _i7.PageInfo<AuthRouteArgs> page =
      _i7.PageInfo<AuthRouteArgs>(name);
}

class AuthRouteArgs {
  const AuthRouteArgs({
    this.key,
    required this.onAuthSuccess,
  });

  final _i8.Key? key;

  final dynamic Function() onAuthSuccess;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key, onAuthSuccess: $onAuthSuccess}';
  }
}

/// generated route for
/// [_i2.ForgotPasswordRoute]
class ForgotPasswordRoute extends _i7.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i7.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

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
/// [_i4.LoginRoute]
class LoginRoute extends _i7.PageRouteInfo<void> {
  const LoginRoute({List<_i7.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i5.NotificationRoute]
class NotificationRoute extends _i7.PageRouteInfo<void> {
  const NotificationRoute({List<_i7.PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i6.SignupRoute]
class SignupRoute extends _i7.PageRouteInfo<void> {
  const SignupRoute({List<_i7.PageRouteInfo>? children})
      : super(
          SignupRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignupRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}
