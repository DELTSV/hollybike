import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app.dart';
import 'package:hollybike/auth/bloc/auth_api.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/bloc/auth_repository.dart';
import 'package:hollybike/auth/bloc/auth_session_repository.dart';
import 'package:hollybike/notification/bloc/notification_bloc.dart';
import 'package:hollybike/notification/bloc/notification_repository.dart';
import 'package:hollybike/profile/bloc/profile_api.dart';
import 'package:hollybike/profile/bloc/profile_bloc.dart';
import 'package:hollybike/profile/bloc/profile_repository.dart';

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
              notificationBloc: BlocProvider.of<NotificationBloc>(context),
            ),
          ),
          RepositoryProvider(
            create: (context) => AuthRepository(authApi: AuthApi()),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(
                authRepository: RepositoryProvider.of<AuthRepository>(context),
                notificationRepository:
                    RepositoryProvider.of<NotificationRepository>(context),
              ),
            ),
            BlocProvider<ProfileBloc>(
              create: (context) => ProfileBloc(),
            ),
          ],
          child: RepositoryProvider<AuthSessionRepository>(
            create: (context) => AuthSessionRepository(
              authBloc: BlocProvider.of<AuthBloc>(context),
            ),
            child: MultiRepositoryProvider(
              providers: [
                RepositoryProvider<ProfileRepository>(
                  create: (context) => ProfileRepository(
                    authSessionRepository: RepositoryProvider.of<AuthSessionRepository>(context),
                    profileBloc: BlocProvider.of<ProfileBloc>(context),
                    profileApi: ProfileApi(),
                  ),
                ),
              ],
              child: const App(),
            ),
          ),
        ),
      ),
    );
  }
}
