/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class TabDescription {
  final String title;
  final IconData icon;
  final Widget fragment;

  const TabDescription({
    required this.title,
    required this.icon,
    required this.fragment,
  });
}
