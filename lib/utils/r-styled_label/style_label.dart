// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/utils/r-text/type.dart';

class RStyledLabel extends StatelessWidget {
  final IconData? icon;
  final Color? color;
  final Color? iconColor;
  final Color? textColor;
  final String? text;
  final double? iconSize;
  const RStyledLabel({
    Key? key,
    required this.text,
    this.color,
    this.icon,
    this.iconColor,
    this.textColor,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 5),
          height: 25,
          // width: 150,
          padding: EdgeInsets.only(left: 30, right: 10),
          decoration: BoxDecoration(color: color ?? Colors.white, borderRadius: BorderRadius.all(Radius.circular(100))),
          child: Center(
              child: RText(
            title: text,
            type: RTextType.label,
            color: textColor ?? Colors.white,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          )),
        ),
        Positioned(
            top: 8,
            left: 2,
            child: Icon(
              icon,
              size: iconSize == null ? 18 : iconSize!,
              color: iconColor ?? Colors.white,
            ))
      ],
    );
  }
}
