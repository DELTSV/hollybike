import 'package:flutter/material.dart';
import 'package:hollybike/shared/utils/render_nullable_widget_to_list.dart';
import 'package:hollybike/shared/widgets/bar/bottom_bar.dart';

class Hud extends StatelessWidget {
  final Widget? appBar;
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
              dimension: 120,
            ),
            Expanded(
              child: body ?? Container(),
            )
          ]),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface,
                  Colors.transparent,
                ],
              ),
            ),
            constraints: const BoxConstraints.expand(height: 180),
          )
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
