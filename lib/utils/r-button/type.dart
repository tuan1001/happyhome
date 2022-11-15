// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rcore/utils/color/theme.dart';

class RButtonType {
  static const int theme = 1;
  static const int primary = 2;
  static const int secondary = 3;
  static const int success = 4;
  static const int danger = 5;
  static const int warning = 6;
  static const int info = 7;
  static const int light = 8;
  static const int dark = 9;
}

Color rButtonBackground(int? type) {
  switch(type) {
    case RButtonType.theme:
      return themeColor;
    case RButtonType.primary:
      return Color.fromRGBO(13, 110, 253, 1);
    case RButtonType.secondary:
      return Color.fromRGBO(108, 117, 125, 1);
    case RButtonType.success:
      return Color.fromRGBO(25, 135, 84, 1);
    case RButtonType.danger:
      return Color.fromRGBO(220, 53, 69, 1);
    case RButtonType.warning:
      return Color.fromRGBO(255, 193, 7, 1);
    case RButtonType.info:
      return Color.fromRGBO(13, 202, 240, 1);
    case RButtonType.light:
      return Color.fromRGBO(248, 249, 250, 1);
    case RButtonType.dark:
      return Color.fromRGBO(33, 37, 41, 1);
    default:
      return themeColor;
  }
}
Color rButtonForeground(int? type) {
  switch(type) {
    case RButtonType.theme:
    case RButtonType.primary:
    case RButtonType.secondary:
    case RButtonType.success:
    case RButtonType.danger:
    case RButtonType.dark:
    case RButtonType.warning:
    case RButtonType.info:
      return Colors.white;
    case RButtonType.light:
      return Colors.black;
    default:
      return Colors.white;
  }
}