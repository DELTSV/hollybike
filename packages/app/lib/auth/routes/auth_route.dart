import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/shared/widgets/app_banner.dart';

@RoutePage()
class AuthRoute extends StatelessWidget {
  final Function() onAuthSuccess;

  const AuthRoute({super.key, required this.onAuthSuccess});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.currentSession != null) onAuthSuccess.call();
      },
      builder: (context, state) => Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.hardEdge,
          child: const Wrap(
            direction: Axis.horizontal,
            children: [
              AppBanner(),
              AutoRouter(),
            ],
          ),
        ),
      ),
    );
  }
}
