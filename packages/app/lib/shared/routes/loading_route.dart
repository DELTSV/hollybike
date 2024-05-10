import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hollybike/shared/widgets/loading_background.dart';
import 'package:hollybike/shared/widgets/loading_title.dart';

@RoutePage()
class LoadingRoute extends StatelessWidget {
  const LoadingRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      alignment: Alignment.center,
      children: [
        LoadingBackground(),
        LoadingTitle(),
      ],
    );
  }
}
