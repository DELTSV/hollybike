import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app.dart';
import 'package:hollybike/auth/bloc/auth_api.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/bloc/auth_persistence.dart';
import 'package:hollybike/auth/bloc/auth_repository.dart';
import 'package:hollybike/auth/bloc/auth_session_repository.dart';
import 'package:hollybike/event/bloc/event_bloc.dart';
import 'package:hollybike/event/bloc/event_repository.dart';
import 'package:hollybike/notification/bloc/notification_bloc.dart';
import 'package:hollybike/notification/bloc/notification_repository.dart';
import 'package:hollybike/profile/bloc/profile_api.dart';
import 'package:hollybike/profile/bloc/profile_bloc.dart';
import 'package:hollybike/profile/bloc/profile_repository.dart';
import 'package:hollybike/theme/bloc/theme_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'event/bloc/event_api.dart';

void main() {
  initializeDateFormatting("fr_FR").then((value) => Intl.defaultLocale = "fr_FR");
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
            create: (context) => AuthRepository(
              authApi: AuthApi(),
              authPersistence: AuthPersistence(),
            ),
          ),
          RepositoryProvider(
            create: (context) => EventRepository(
              eventApi: EventApi(),
            ),
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
            BlocProvider<ThemeBloc>(
              create: (context) => ThemeBloc(),
            ),
            BlocProvider<ProfileBloc>(
              create: (context) => ProfileBloc(),
            ),
            BlocProvider<EventBloc>(
              create: (context) => EventBloc(
                eventRepository: RepositoryProvider.of<EventRepository>(context),
              ),
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
                    authSessionRepository:
                        RepositoryProvider.of<AuthSessionRepository>(context),
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
