/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

List<Widget> renderNullableWidgetToList(Widget? widget) =>
    widget == null ? <Widget>[] : [widget];
