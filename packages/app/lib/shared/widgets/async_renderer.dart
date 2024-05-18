import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AsyncRenderer<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T) builder;
  final Widget placeholder;

  const AsyncRenderer({
    super.key,
    required this.future,
    required this.builder,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) => switch (snapshot) {
        AsyncSnapshot<T>(data: final data) when data != null => builder(data),
        _ => placeholder,
      },
    );
  }
}
