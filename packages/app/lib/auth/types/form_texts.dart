/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef Link = ({
  String? description,
  String buttonText,
  void Function() onDestinationClick,
});

class FormTexts {
  final Link? link;
  final String? submit;

  const FormTexts({
    this.link,
    this.submit,
  });

  static toWidgetArray(String? text, {TextStyle? style}) {
    if (text == null || text.isEmpty) {
      return <Widget>[];
    }
    return <Widget>[Text(text, style: style)];
  }
}
