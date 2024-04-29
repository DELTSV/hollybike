import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef Link = ({
  String? description,
  String buttonText,
  PageRouteInfo<dynamic> destination,
});

class FormTexts {
  final String? title;
  final String? description;
  final Link? link;

  const FormTexts({
    this.title,
    this.description,
    this.link,
  });

  static toWidgetArray(String? text, {TextStyle? style}) {
    if (text == null || text.isEmpty) {
      return <Widget>[];
    }
    return <Widget>[Text(text, style: style)];
  }
}
