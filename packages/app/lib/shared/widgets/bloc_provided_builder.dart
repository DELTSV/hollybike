/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocProvidedBuilder<B extends StateStreamable<S>, S>
    extends StatelessWidget {
  final Widget Function(BuildContext context, B bloc, S state) builder;

  const BlocProvidedBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      builder: (context, state) => builder(
        context,
        context.read<B>(),
        state,
      ),
    );
  }
}
