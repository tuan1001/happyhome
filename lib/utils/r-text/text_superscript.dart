import 'package:flutter/material.dart';
import 'package:rcore/utils/r-text/type.dart';

class RTextSupscript extends StatelessWidget {
  final String? title;
  final String superscript;
  final int? type;
  final Color? color;
  final Color? backgroundColor;
  final TextAlign? align;
  final int? maxLines;
  final FontStyle? fontStyle;
  final double? fontSize;
  final AlignmentGeometry? alignment;
  const RTextSupscript({
    Key? key,
    required this.title,
    required this.superscript,
    this.type,
    this.color,
    this.backgroundColor,
    this.align,
    this.maxLines,
    this.fontStyle,
    this.fontSize,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment == null ? Alignment.centerLeft : alignment!,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: title,
                    style: TextStyle(
                      fontSize: fontSize ?? getFontSize(type),
                      fontWeight: getFontWeight(type),
                      color: color ?? Colors.black,
                      fontStyle: fontStyle,
                      backgroundColor: backgroundColor ?? Colors.transparent,
                    ),
                  ),
                  WidgetSpan(
                    child: Transform.translate(
                      offset: const Offset(0.0, -7.0),
                      child: Text(
                        superscript,
                        style: TextStyle(fontSize: getFontSize(type)! - 4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: TextStyle(
                    fontSize: fontSize ?? getFontSize(type),
                    fontWeight: getFontWeight(type),
                    color: color ?? Colors.black,
                    fontStyle: fontStyle,
                    backgroundColor: backgroundColor ?? Colors.transparent,
                  ),
                ),
                WidgetSpan(
                  child: Transform.translate(
                    offset: const Offset(0.0, -7.0),
                    child: Text(
                      superscript,
                      style: TextStyle(fontSize: getFontSize(type)! - 4),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
