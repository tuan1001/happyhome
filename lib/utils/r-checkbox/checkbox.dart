// ignore_for_file: prefer_if_null_operators, prefer_conditional_assignment

import 'package:flutter/material.dart';
import 'package:rcore/utils/color/theme.dart';
import 'package:rcore/utils/r-text/title.dart';

class RCheckBox extends StatefulWidget {
  final String? title;
  final Function(bool?)? onPressed;
  final bool? currentValue;
  const RCheckBox({
    Key? key,
    required this.title,
    required this.onPressed,
    this.currentValue,
  }) : super(key: key);

  @override
  State<RCheckBox> createState() => _RCheckBoxState();
}

class _RCheckBoxState extends State<RCheckBox> {
  bool? checked;
  @override
  Widget build(BuildContext context) {
    if (checked == null) {
      checked = widget.currentValue == null ? false : widget.currentValue;
    }
    return Row(
      children: [
        SizedBox(
          width: 25,
          height: 25,
          child: Checkbox(
              activeColor: themeColor,
              side: const BorderSide(color: themeColor),
              //fillColor: MaterialStateProperty.all(Colors.white),
              //checkColor: themeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(color: themeColor),
              ),
              value: checked,
              onChanged: (value) {
                setState(() {
                  checked = value;
                });
                widget.onPressed!(value);
              }),
        ),
        RText(
          title: widget.title,
          color: themeColor,
        )
      ],
    );
  }
}
