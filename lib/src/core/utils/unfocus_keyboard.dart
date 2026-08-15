import 'package:flutter/widgets.dart';

void unfocusKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}
