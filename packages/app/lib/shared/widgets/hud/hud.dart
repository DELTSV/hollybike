/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

import '../bar/bottom_bar.dart';

class Hud extends StatelessWidget {
  final Widget? appBar;
  final Widget? floatingActionButton;
  final Widget? body;
  final bool displayNavBar;

  const Hud({
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.body,
    this.displayNavBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar == null
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Center(child: appBar as Widget),
            ),
      floatingActionButton: floatingActionButton,
      body: Column(
        children: <Widget>[
          const SizedBox(height: 2),
          Expanded(
            child: SafeArea(
              top: false,
              bottom: true,
              child: body ?? Container(),
            ),
          )
        ],
      ),
      bottomNavigationBar: displayNavBar ? const BottomBar() : null,
    );
  }
}
