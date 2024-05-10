import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final _textTheme = const TextTheme(
    titleMedium: TextStyle(
      fontVariations: [FontVariation.weight(800)],
      fontSize: 28,
    ),
    titleSmall: TextStyle(
      fontVariations: [FontVariation.weight(700)],
      fontSize: 14,
    ),
  );

  ThemeBloc() : super(ThemeInitial()) {
    on<ThemeSwitch>((event, emit) {
      emit(ThemeSwitched(state));
    });
  }

  ColorScheme get _colorScheme {
    if (state.isDark) {
      return const ColorScheme.dark(
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
      );
    }

    return const ColorScheme.light(
      error: Color(0xffd20f39),
      background: Color(0xffdce0e8),
      primary: Color(0xffeff1f5),
      primaryContainer: Color(0xffe6e9ef),
      onPrimary: Color(0xff5c5f77),
      onPrimaryContainer: Color(0xff4c4f69),
      surface: Color(0xffccd0da),
      onSurface: Color(0xff4c4f69),
      onSurfaceVariant: Color(0xff5c5f77),
      outline: Color(0xff5c5f77),
      secondary: Color(0xff179299),
    );
  }

  InputDecorationTheme get _inputDecorationTheme{
    if (state.isDark) {
      return const InputDecorationTheme(
        focusColor: Color(0xffcdd6f4),
        floatingLabelStyle: TextStyle(color: Color(0xffcdd6f4)),
      );
    }
    return const InputDecorationTheme(
      focusColor: Color(0xff5c5f77),
      floatingLabelStyle: TextStyle(color: Color(0xff5c5f77)),
    );
  }

  TextSelectionThemeData get _textSelectionTheme{
    if (state.isDark) {
      return const TextSelectionThemeData(
        selectionColor: Color(0x6689b4fa),
        cursorColor: Color(0xffb4befe),
        selectionHandleColor: Color(0xffb4befe),
      );
    }
    return const TextSelectionThemeData(
      selectionColor: Color(0x661e66f5),
      cursorColor: Color(0xff7287fd),
      selectionHandleColor: Color(0xff7287fd),
    );
  }

  ThemeData get getThemeData {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      textTheme: _textTheme,
      colorScheme: _colorScheme,
      inputDecorationTheme: _inputDecorationTheme,
      textSelectionTheme: _textSelectionTheme,
    );
  }
}
