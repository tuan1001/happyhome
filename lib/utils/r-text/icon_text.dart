// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

import 'package:rcore/utils/r-text/type.dart';

class RIconText extends StatelessWidget {
  final String? title;
  final int? type;
  final int? maxLines;
  final Color? color;
  final IconData? icon;
  final double? width;
  final double? iconSize;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  const RIconText({
    Key? key,
    required this.title,
    this.type,
    this.color,
    required this.icon,
    this.width,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.maxLines,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize ?? 15, color: color ?? Colors.black),
          SizedBox(width: 2),
          SizedBox(
            width: width,
            child: Text(
              title ?? '',
              style: TextStyle(
                fontSize: getFontSize(type),
                fontWeight: getFontWeight(type),
                color: color ?? Colors.black,
              ),
              maxLines: maxLines ?? 3,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
