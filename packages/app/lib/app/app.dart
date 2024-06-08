import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app_router.dart';
import 'package:hollybike/auth/guards/auth_stream.dart';
import 'package:hollybike/theme/bloc/theme_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';


class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    initializeDateFormatting("fr_FR")
        .then((value) => Intl.defaultLocale = "fr_FR");

    MapboxOptions.setAccessToken(
      const String.fromEnvironment('PUBLIC_ACCESS_TOKEN'),
    );
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );

    final appRouter = AppRouter(context: context);
    final authChangeNotifier = AuthStream(context);

    return BlocBuilder<ThemeBloc, ThemeState>(
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
    );
  }
}
