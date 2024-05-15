import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/hud/widgets/hud_bottom_bar.dart';

@RoutePage()
class HudRoute extends StatelessWidget {
  const HudRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          Expanded(
            child: AutoRouter(),
          ),
          HudBottomBar(),
        ],
      ),
    );
  }
}
