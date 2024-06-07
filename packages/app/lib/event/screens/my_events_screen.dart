import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:hollybike/shared/widgets/bar/top_bar.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';

import '../../shared/widgets/bar/top_bar_title.dart';

@RoutePage()
class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Hud(
      displayNavBar: true,
      appBar: TopBar(
        title: TopBarTitle('Mes événements'),
      ),
      body: Center(
        child: Text('Mes événements'),
      ),
    );
  }
}
