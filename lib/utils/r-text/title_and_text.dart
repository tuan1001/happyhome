// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/utils/r-text/type.dart';

import '../color/theme.dart';

class RTitleAndText extends StatelessWidget {
  final String? title;
  final String? text;
  final bool? underline;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final double? contentWidth;
  const RTitleAndText({
    Key? key,
    required this.title,
    required this.text,
    this.underline,
    this.maxLines,
    this.textOverflow,
    this.contentWidth,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: underline == true ? Colors.grey.shade200 : Colors.transparent))),
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RText(title: title, type: RTextType.subtitle, color: themeColor),
          if (maxLines == null || textOverflow == null)
            RText(title: text ?? '', type: RTextType.text)
          else
            Container(
                alignment: Alignment.centerRight,
                width: contentWidth,
                child: RText(title: text ?? '', type: RTextType.text, maxLines: maxLines, textOverflow: textOverflow)),
        ],
      ),
    );
  }
}
