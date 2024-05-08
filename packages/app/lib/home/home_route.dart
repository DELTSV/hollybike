import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';

@RoutePage()
class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "You'r currently connected to :",
              ),
              Text(
                '${state.currentSession?.host}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                child: TextButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context)
                        .add(AuthStoreCurrentSession());
                    AutoRouter.of(context).push(const LoginRoute());
                  },
                  child: const Text("Add an account"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
