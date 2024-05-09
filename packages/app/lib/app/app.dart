import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/app/app_router.dart';
import 'package:hollybike/auth/guards/auth_stream.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(context: context);
    final authChangeNotifier = AuthStream(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Hollybike',
          theme: _getAppTheme(),
          routerConfig: appRouter.config(
            reevaluateListenable: authChangeNotifier,
          ),
        );
      },
    );
  }

  ThemeData _getAppTheme() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0x20000000),
      systemNavigationBarColor: Color(0x20000000),
    ));
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      inputDecorationTheme: const InputDecorationTheme(
        focusColor: Color(0xffcdd6f4),
      ),
      colorScheme: const ColorScheme.light(
        error: Color(0xfff38ba8),
        background: Color(0xff11111b),
        primary: Color(0xff1e1e2e),
        primaryContainer: Color(0xff181825),
        onPrimary: Color(0xffcdd6f4),
        onPrimaryContainer: Color(0xffa6adc8),
        surface: Color(0xff313244),
        onSurface: Color(0xffbac2de),
        onSurfaceVariant: Color(0xffcdd6f4),
        outline: Color(0xffcdd6f4),
        secondary: Color(0xff94e2d5),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: Color(0x6689b4fa),
        cursorColor: Color(0xffb4befe),
        selectionHandleColor: Color(0xffb4befe),
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(
          fontVariations: [FontVariation.weight(800)],
          fontSize: 28,
        ),
        titleSmall: TextStyle(
          fontVariations: [FontVariation.weight(700)],
          fontSize: 14,
        ),
      ),
    );
  }
}
