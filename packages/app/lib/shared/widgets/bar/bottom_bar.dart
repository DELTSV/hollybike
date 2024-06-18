import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/profile/widgets/profile_bottom_bar_button.dart';
import 'package:hollybike/shared/widgets/bar/bottom_bar_icon_button.dart';

import '../../../app/app_router.gr.dart';
import '../../../profile/bloc/profile_bloc.dart';

class NavRoute {
  final String routeName;
  final PageRouteInfo route;

  const NavRoute({
    required this.routeName,
    required this.route,
  });
}

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final _routes = [
    const NavRoute(
      routeName: EventsRoute.name,
      route: EventsRoute(),
    ),
    const NavRoute(
      routeName: SearchRoute.name,
      route: SearchRoute(),
    ),
    const NavRoute(
      routeName: MeRoute.name,
      route: MeRoute(),
    ),
  ];

  int _getCurrentPageIndex(BuildContext context) {
    final currentRouteName = context.router.current.name;
    final index =
        _routes.indexWhere((route) => route.routeName == currentRouteName);
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return NavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          indicatorColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: _getCurrentPageIndex(context),
          onDestinationSelected: (index) {
            final currentRouteName = context.router.current.name;
            if (_routes[index].routeName != currentRouteName) {
              context.router.push(_routes[index].route);
            }
          },
          destinations: const [
            BottomBarIconButton(
              icon: Icons.event,
              label: 'Événements',
            ),
            BottomBarIconButton(
              icon: Icons.search,
              label: 'Recherche',
            ),
            ProfileBottomBarButton(),
          ],
        );
      },
    );
  }
}
