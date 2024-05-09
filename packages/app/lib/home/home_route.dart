import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/home/widgets/app_navigation_bar.dart';

@RoutePage()
class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                ),
                const AppNavigationBar(),
              ],
            ),
          ),
        );
      },
    );
  }
}
