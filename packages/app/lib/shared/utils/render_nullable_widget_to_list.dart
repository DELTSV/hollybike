import 'package:flutter/material.dart';

List<Widget> renderNullableWidgetToList(Widget? widget) =>
    widget == null ? <Widget>[] : [widget];
