part of 'theme_bloc.dart';

@immutable
abstract class ThemeState {
  final bool isDark;

  ThemeState({required this.isDark});
}

class ThemeInitial extends ThemeState {
  ThemeInitial() : super(isDark: false);
}

class ThemeSwitched extends ThemeState {
  ThemeSwitched(ThemeState currentState) : super(isDark: !currentState.isDark);
}
