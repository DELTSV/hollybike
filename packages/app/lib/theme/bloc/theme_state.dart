/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
part of 'theme_bloc.dart';

@immutable
abstract class ThemeState {
  final bool isDark;

  const ThemeState({required this.isDark});
}

class ThemeInitial extends ThemeState {
  const ThemeInitial() : super(isDark: true);
}

class ThemeSwitched extends ThemeState {
  ThemeSwitched(ThemeState currentState) : super(isDark: !currentState.isDark);
}
