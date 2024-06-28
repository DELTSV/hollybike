import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AsyncRenderer<T> extends StatelessWidget {
  final FutureOr<T> future;
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
    if (future is T) return builder(future as T);

    return FutureBuilder(
      future: future as Future<T>,
      builder: (context, snapshot) => switch (snapshot) {
        AsyncSnapshot<T>(data: final data) when data != null => builder(data),
        _ => placeholder,
      },
    );
  }
}
