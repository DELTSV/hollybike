import 'package:flutter/material.dart';

class TopBarTitle extends StatelessWidget {
  final String title;

  const TopBarTitle(
    this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
