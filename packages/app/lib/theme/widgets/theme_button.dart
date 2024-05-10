import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/theme/bloc/theme_bloc.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () => _handleTap(context),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            padding: const EdgeInsets.all(12),
          ),
          icon: Icon(
            state.isDark ? Icons.sunny : Icons.nights_stay_sharp,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        );
      },
    );
  }

  void _handleTap(BuildContext context) {
    BlocProvider.of<ThemeBloc>(context).add(ThemeSwitch());
  }
}
