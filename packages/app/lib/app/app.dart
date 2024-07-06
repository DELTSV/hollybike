import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hollybike/app/app_router.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';
import 'package:hollybike/auth/guards/auth_stream.dart';
import 'package:hollybike/notification/bloc/notification_bloc.dart';
import 'package:hollybike/theme/bloc/theme_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class App extends StatefulWidget {
  final AuthPersistence authPersistence;

  const App({super.key, required this.authPersistence});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter appRouter;
  late final AuthStream authChangeNotifier;

  @override
  void initState() {
    super.initState();

    initializeDateFormatting("fr_FR")
        .then((value) => Intl.defaultLocale = "fr_FR");

    MapboxOptions.setAccessToken(
      const String.fromEnvironment('PUBLIC_ACCESS_TOKEN'),
    );

    appRouter = AppRouter(authPersistence: widget.authPersistence);
    authChangeNotifier = AuthStream(
      context,
      authPersistence: widget.authPersistence,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthConnected) {
          context.read<NotificationBloc>().add(InitNotificationService());
        } else if (state is AuthDisconnected) {
          context.read<NotificationBloc>().add(InitNotificationService());
        }
      },
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarContrastEnforced: false,
              systemStatusBarContrastEnforced: false,
              systemNavigationBarIconBrightness:
                  state.isDark ? Brightness.light : Brightness.dark,
              statusBarIconBrightness:
                  state.isDark ? Brightness.light : Brightness.dark,
            ),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: MaterialApp.router(
                localizationsDelegates: GlobalMaterialLocalizations.delegates,
                supportedLocales: const [
                  Locale('fr', 'FR'),
                ],
                title: 'Hollybike',
                theme: BlocProvider.of<ThemeBloc>(context).getThemeData,
                routerConfig: appRouter.config(
                  reevaluateListenable: authChangeNotifier,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
