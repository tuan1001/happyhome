// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

import 'package:rcore/utils/r-button/type.dart';

class RButton extends StatelessWidget {
  final String? text;
  final Function()? onPressed;
  final Function(bool)? onFocused;
  final int? type;
  final double? radius;

  final bool? styled;
  final FocusNode? focusNode;
  final IconData? icon;
  final bool? autofocus;
  final Color? backgroundColor;
  final Color? foregroundColor;
  const RButton({
    Key? key,
    this.text,
    this.onPressed,
    this.onFocused,
    this.type,
    this.radius,
    this.styled,
    this.focusNode,
    this.icon,
    this.autofocus,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 45,
          child: ElevatedButton(
              focusNode: focusNode,
              onFocusChange: onFocused,
              autofocus: autofocus ?? false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon == null
                      ? Container()
                      : Icon(
                          icon!,
                          size: 20,
                          color: rButtonForeground(type),
                        ),
                  text == null ? Container() : Text(text!)
                ],
              ),
              onPressed: onPressed,
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                foregroundColor: MaterialStateProperty.all<Color>(foregroundColor ?? rButtonForeground(type)),
                backgroundColor: MaterialStateProperty.all<Color>(backgroundColor ?? rButtonBackground(type)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius == null ? 0 : radius!),
                    side: BorderSide(color: backgroundColor ?? rButtonBackground(type)))),
              )),
        ),
        styled == true
            ? Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  child: Center(
                    child: Icon(Icons.arrow_forward, color: Color.fromRGBO(255, 255, 255, 0.3)),
                  ),
                ))
            : Container()
      ],
    );
  }
}
