import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app.dart';
import 'package:hollybike/auth/bloc/auth_api.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/bloc/auth_repository.dart';
import 'package:hollybike/notification/bloc/notification_bloc.dart';
import 'package:hollybike/notification/bloc/notification_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationBloc(),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => NotificationRepository(
                notificationBloc: BlocProvider.of<NotificationBloc>(context)),
          ),
          RepositoryProvider(
            create: (context) => AuthRepository(authApi: AuthApi()),
          ),
        ],
        child: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: RepositoryProvider.of<AuthRepository>(context),
            notificationRepository:
                RepositoryProvider.of<NotificationRepository>(context),
          ),
          child: const App(),
        ),
      ),
    );
  }
}
