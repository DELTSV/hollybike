// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;
import 'package:hollybike/auth/widgets/auth_route.dart' as _i1;
import 'package:hollybike/auth/widgets/login_route.dart' as _i3;
import 'package:hollybike/auth/widgets/signup_route.dart' as _i4;
import 'package:hollybike/home/home_route.dart' as _i2;

abstract class $AppRouter extends _i5.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    AuthRoute.name: (routeData) {
      final args = routeData.argsAs<AuthRouteArgs>();
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AuthRoute(
          key: args.key,
          onAuthSuccess: args.onAuthSuccess,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomeRoute(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.LoginRoute(),
      );
    },
    SignupRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.SignupRoute(),
      );
    },
  };
}

/// generated route for
/// [_i1.AuthRoute]
class AuthRoute extends _i5.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({
    _i6.Key? key,
    required dynamic Function() onAuthSuccess,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          AuthRoute.name,
          args: AuthRouteArgs(
            key: key,
            onAuthSuccess: onAuthSuccess,
          ),
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static const _i5.PageInfo<AuthRouteArgs> page =
      _i5.PageInfo<AuthRouteArgs>(name);
}

class AuthRouteArgs {
  const AuthRouteArgs({
    this.key,
    required this.onAuthSuccess,
  });

  final _i6.Key? key;

  final dynamic Function() onAuthSuccess;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key, onAuthSuccess: $onAuthSuccess}';
  }
}

/// generated route for
/// [_i2.HomeRoute]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i3.LoginRoute]
class LoginRoute extends _i5.PageRouteInfo<void> {
  const LoginRoute({List<_i5.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i4.SignupRoute]
class SignupRoute extends _i5.PageRouteInfo<void> {
  const SignupRoute({List<_i5.PageRouteInfo>? children})
      : super(
          SignupRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignupRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}
