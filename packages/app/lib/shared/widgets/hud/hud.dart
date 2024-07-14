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
      body: Stack(
        children: [
          Column(children: <Widget>[
            Expanded(
              child: SafeArea(
                top: false,
                bottom: true,
                child: body ?? Container(),
              ),
            )
          ]),
        ],
      ),
      bottomNavigationBar: displayNavBar ? const BottomBar() : null,
    );
  }
}
