import 'package:flutter/material.dart';

import 'hud_bottom_bar.dart';

class Hud extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? body;

  const Hud({
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: body,
      bottomNavigationBar: const HudBottomBar(),
    );
  }
}
