import 'package:flutter/material.dart';
import 'package:rcore/utils/r-text/type.dart';

class RText extends StatelessWidget {
  final String? title;
  final int? type;
  final Color? color;
  final Color? backgroundColor;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final FontStyle? fontStyle;
  final double? fontSize;
  final AlignmentGeometry? alignment;
  const RText(
      {Key? key,
      required this.title,
      this.type,
      this.color,
      this.backgroundColor,
      this.align,
      this.maxLines,
      this.textOverflow,
      this.fontStyle,
      this.fontSize,
      this.alignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment == null ? Alignment.centerLeft : alignment!,
            child: Text(title ?? '',
                textAlign: align,
                maxLines: maxLines,
                overflow: textOverflow,
                style: TextStyle(
                    fontSize: fontSize ?? getFontSize(type),
                    fontWeight: getFontWeight(type),
                    color: color ?? Colors.black,
                    fontStyle: fontStyle,
                    backgroundColor: backgroundColor ?? Colors.transparent)),
          )
        : Text(title ?? '',
            textAlign: align,
            maxLines: maxLines,
            overflow: textOverflow,
            style: TextStyle(
                fontSize: fontSize ?? getFontSize(type),
                fontWeight: getFontWeight(type),
                color: color ?? Colors.black,
                fontStyle: fontStyle,
                backgroundColor: backgroundColor ?? Colors.transparent));
  }
}
