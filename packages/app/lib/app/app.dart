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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0x20000000),
      systemNavigationBarColor: Color(0x20000000),
    ));
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );

    final appRouter = AppRouter(context: context);
    final authChangeNotifier = AuthStream(context);

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) => MaterialApp.router(
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
    );
  }
}
