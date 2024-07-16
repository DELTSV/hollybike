/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/profile/widgets/profile_bottom_bar_button.dart';
import 'package:hollybike/shared/utils/safe_set_state.dart';

import '../../../app/app_router.gr.dart';
import '../../../profile/bloc/profile_bloc/profile_bloc.dart';

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
  late int _currentIndex;

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

  @override
  void initState() {
    super.initState();
    _currentIndex = _getRouteIndex(context.router.current.name);

    try {
      context.router.addListener(_routeListener);
    } catch (e) {
      // ignore: avoid_print
    }
  }

  @override
  void dispose() {
    if (context.mounted) {
      context.router.removeListener(_routeListener);
    }
    super.dispose();
  }

  void _routeListener() {
    try {
      if (!context.mounted) return;

      final index = _getRouteIndex(context.router.current.name);

      if (index != -1) {
        safeSetState(() {
          _currentIndex = index;
        });
      }
    } catch (e) {
      // ignore: avoid_print
    }
  }

  int _getRouteIndex(String routeName) {
    try {
      final currentRouteName = context.router.current.name;
      final index =
      _routes.indexWhere((route) => route.routeName == currentRouteName);

      if (index != -1) {
        return index;
      }
    } catch (e) {
      // ignore: avoid_print
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final selectedColor = Theme.of(context).colorScheme.secondary;
        final unselectedColor =
            Theme.of(context).colorScheme.onPrimary.withAlpha(100);

        const iconSize = 30.0;

        return SafeArea(
          child: SizedBox(
            height: 50,
            child: NavBar(
              currentIndex: _currentIndex,
              onSelected: (index) {
                final currentRouteName = context.router.current.name;
                if (_routes[index].routeName != currentRouteName) {
                  context.router.removeWhere((route) {
                    if (route.name == _routes[index].routeName) {
                      return true;
                    }

                    return false;
                  });

                  context.router.push(_routes[index].route);
                }
              },
              children: [
                NavBarItem(
                  selectedIcon: Icon(
                    Icons.event_rounded,
                    color: selectedColor,
                    size: iconSize,
                  ),
                  icon: Icon(
                    Icons.event_rounded,
                    color: unselectedColor,
                    size: iconSize,
                  ),
                ),
                NavBarItem(
                  selectedIcon: Icon(
                    Icons.search_rounded,
                    color: selectedColor,
                    size: iconSize,
                  ),
                  icon: Icon(
                    Icons.search_rounded,
                    color: unselectedColor,
                    size: iconSize,
                  ),
                ),
                NavBarItem(
                  selectedIcon: ProfileBottomBarButton(
                    isSelected: true,
                    size: iconSize,
                    color: selectedColor,
                  ),
                  icon: ProfileBottomBarButton(
                    isSelected: false,
                    size: iconSize,
                    color: unselectedColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NavBarItem {
  final Widget selectedIcon;
  final Widget icon;

  const NavBarItem({
    required this.selectedIcon,
    required this.icon,
  });
}

class NavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onSelected;
  final List<NavBarItem> children;

  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onSelected,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      for (var i = 0; i < children.length; i++)
        Expanded(
          child: GestureDetector(
            onTap: () => onSelected(i),
            child: _buildContainer(context, i),
          ),
        ),
    ]);
  }

  Widget _buildContainer(BuildContext context, int index) {
    final selectedIcon = currentIndex == index
        ? children[index].selectedIcon
        : children[index].icon;

    return Container(
      color: Colors.transparent,
      height: double.infinity,
      child: selectedIcon,
    );
  }
}
