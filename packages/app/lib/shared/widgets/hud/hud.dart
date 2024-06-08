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
      extendBodyBehindAppBar: true,
      appBar: appBar == null
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: appBar as Widget,
            ),
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          Column(children: <Widget>[
            const SizedBox.square(
              dimension: 105,
            ),
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
