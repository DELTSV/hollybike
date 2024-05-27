import 'package:flutter/material.dart';

class FieldFocusNode {
  final FocusNode focusNode;
  final FocusNode? controlFocusNode;

  FieldFocusNode({
    bool? hasControlNode,
  })  : focusNode = FocusNode(),
        controlFocusNode = hasControlNode == true ? FocusNode() : null;
}
