import 'package:flutter/material.dart';

class CustomFocus extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    return false;
  }
}