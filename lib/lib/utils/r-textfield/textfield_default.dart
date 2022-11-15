// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:rcore/utils/color/theme.dart';
import 'package:rcore/utils/r-textfield/type.dart';

import '../r-text/text_superscript.dart';
import '../r-text/type.dart';

class RTextFieldDefault extends StatelessWidget {
  final String? label;
  final String? labelsuperscript;
  final TextEditingController? controller;
  final Color? color;
  final int? maxLength;
  final int? type;
  final Function(String)? onSubmitted;
  const RTextFieldDefault({
    Key? key,
    required this.label,
    required this.controller,
    this.color,
    this.type,
    this.onSubmitted,
    this.maxLength,
    this.labelsuperscript,
  }) : super(key: key);

  TextInputType getInputType() {
    switch (type) {
      case RTextFieldType.password:
        return TextInputType.visiblePassword;
      case RTextFieldType.price:
      case RTextFieldType.number:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 7, bottom: 7),
        child: Column(
          children: [
            TextFormField(
                maxLength: maxLength,
                controller: controller,
                cursorColor: color == null ? themeColor : color!,
                obscureText: type == RTextFieldType.password,
                enableSuggestions: !(type == RTextFieldType.password),
                autocorrect: !(type == RTextFieldType.password),
                keyboardType: getInputType(),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: onSubmitted ?? (value) {},
                decoration: InputDecoration(
                  counterText: '',
                  // hintText: label,
                  label: RTextSupscript(
                    title: label,
                    superscript: labelsuperscript ?? '',
                    type: RTextType.text,
                    color: color ?? themeColor,
                  ),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: color == null ? themeColor : color!)),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                )),
          ],
        ));
  }
}
