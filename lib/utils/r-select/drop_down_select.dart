// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_conditional_assignment, prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rcore/utils/color/theme.dart';
import 'package:darq/darq.dart';

import '../r-text/text_superscript.dart';
import '../r-text/title.dart';
import '../r-text/type.dart';

class RDropDownDefault extends StatelessWidget {
  final String? hintText;
  final String? label;
  final String? labelsuperscript;
  final Color? color;

  final List<Map<String, dynamic>>? items;
  final Function(Map<String, dynamic>?)? onChanged;
  final String? keyDisplay;
  final Map<String, dynamic>? currentValue;
  final Function()? callback;
  const RDropDownDefault({
    Key? key,
    required this.label,
    required this.items,
    required this.onChanged,
    required this.keyDisplay,
    this.hintText,
    this.currentValue,
    this.callback,
    this.labelsuperscript,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? selectedvalue;
    bool initList = false;
    bool loadedCurrentValue = false;
    List<DropdownMenuItem<Map<String, dynamic>?>> listItems = [];
    callback == null ? null : callback!();
    if (!initList) {
      // listItems.add(DropdownMenuItem<Map<String, dynamic>?>(
      //   value: null,
      //   child: RText(title: widget.hintText == null ? '' : widget.hintText, type: RTextType.text, align: TextAlign.left, color: Colors.grey),
      // ));
      listItems.addAll(List<DropdownMenuItem<Map<String, dynamic>?>>.generate(
          items!.length,
          (index) => DropdownMenuItem<Map<String, dynamic>?>(
                value: items![index],
                child: RText(
                  title: items![index][keyDisplay],
                  fontSize: 16,
                  type: RTextType.text,
                  align: TextAlign.left,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              )));
      initList = true;
    }
    if (!loadedCurrentValue && currentValue != null && selectedvalue == null) {
      selectedvalue = items!.firstWhereOrDefault((value) => value['id'] == currentValue!['id']);
      loadedCurrentValue = true;
    }
    return DropdownButtonFormField<Map<String, dynamic>?>(
        decoration: InputDecoration(
          hintText: label,
          label: RTextSupscript(
            title: label,
            superscript: labelsuperscript ?? '',
            type: RTextType.text,
            color: color ?? themeColor,
          ),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: themeColor)),
        ),
        iconSize: 20,
        value: selectedvalue,
        icon: Icon(FontAwesomeIcons.angleDown, color: themeColor),
        isExpanded: true,
        style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 20),
        items: listItems,
        onChanged: (value) {
          onChanged!(value);
        });
  }
}
