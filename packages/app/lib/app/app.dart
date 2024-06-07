import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app_router.dart';
import 'package:hollybike/auth/guards/auth_stream.dart';
import 'package:hollybike/theme/bloc/theme_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

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
