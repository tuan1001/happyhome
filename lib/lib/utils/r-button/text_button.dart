// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rcore/utils/color/theme.dart';
import 'package:rcore/utils/r-text/type.dart';

class RTextButton extends StatelessWidget {
  final String? text;
  final Function()? onPressed;
  final Color? color;
  final int? type;
  final IconData? icon;
  final MainAxisAlignment? alignment;
  const RTextButton({Key? key, required this.text, required this.onPressed, this.color, this.type, this.icon, this.alignment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero, minimumSize: Size(50, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap, alignment: Alignment.centerLeft),
        child: Row(
          mainAxisAlignment: alignment != null ? alignment! : MainAxisAlignment.center,
          children: [
            icon == null ? Container() : Icon(icon, size: 17, color: color == null ? themeColor : color!),
            Text(' ${text!}',
                style: TextStyle(color: color == null ? themeColor : color!, fontSize: getFontSize(type), fontWeight: getFontWeight(type)))
          ],
        ));
  }
}
