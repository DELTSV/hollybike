import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';

@RoutePage()
class AuthRoute extends StatelessWidget {
  final Function() onAuthSuccess;

  const AuthRoute({super.key, required this.onAuthSuccess});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.token != null) onAuthSuccess.call();
      },
      builder: (context, state) => Scaffold(
        body: Center(
          child: Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hollybike",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const AutoRouter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
