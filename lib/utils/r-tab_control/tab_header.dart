import 'package:flutter/material.dart';
import 'package:rcore/utils/color/theme.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/utils/r-text/type.dart';

class RTabHeader extends StatelessWidget {
  final String? text;
  const RTabHeader({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RText(title: text, type: RTextType.title, color: themeColor);
  }
}
