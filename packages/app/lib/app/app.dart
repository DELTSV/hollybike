import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/app/app_router.dart';

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(context: context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Hollybike',
          theme: _getAppTheme(),
          routerConfig: appRouter.config(),
        );
      },
    );
  }

  ThemeData _getAppTheme() {
    return ThemeData(
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.dark(
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
        inverseSurface: Colors.red,
        inversePrimary: Colors.red,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: Color(0x6689b4fa),
        cursorColor: Color(0xffb4befe),
        selectionHandleColor: Color(0xffb4befe),
      ),
    );
  }
}
