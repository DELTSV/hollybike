import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/bar/top_bar.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_search_input.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';

@RoutePage()
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Hud(
      appBar: TopBar(
        title: TopBarSearchInput(
          onSearchRequested: (_) {},
        ),
        noPadding: true,
      ),
      body: const Column(
        children: [],
      ),
      displayNavBar: true,
    );
  }
}
