import 'package:flutter/material.dart';
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
              dimension: 95,
            ),
            Expanded(
              child: body ?? Container(),
            )
          ]),
          Column(
            children: [
              const SizedBox.square(
                dimension: 95,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.surface,
                      Colors.transparent,
                    ],
                  ),
                ),
                constraints: const BoxConstraints.expand(height: 20),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
