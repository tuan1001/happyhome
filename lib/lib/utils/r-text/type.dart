
import 'package:flutter/cupertino.dart';

class RTextType {
  static const int label = 1;
  static const int text = 2;
  static const int subtitle = 3;
  static const int title = 4;
  static const int header2 = 5;
  static const int header1 = 6;
}

  double? getFontSize(int? type) {
    switch(type) {
      case RTextType.label:
        return 11;
      case RTextType.text:
        return 13;
      case RTextType.subtitle:
        return 14;
      case RTextType.title:
        return 16;
      case RTextType.header2:
        return 18;
      case RTextType.header1:
        return 20;
      default:
        return 13;
    }
  }
  FontWeight? getFontWeight(int? type) {
    switch(type) {
      case RTextType.label:
      case RTextType.text:
        return FontWeight.normal;
      case RTextType.subtitle:
      case RTextType.title:
      case RTextType.header2:
      case RTextType.header1:
        return FontWeight.bold;
      default:
        return FontWeight.normal;
    }
  }