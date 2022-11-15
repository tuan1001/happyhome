import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rcore/utils/color/theme.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/utils/r-text/type.dart';
import 'package:darq/darq.dart';

class RDropDown extends StatefulWidget {
  final String? hintText;
  final String? label;
  final List<Map<String, dynamic>>? items;
  final Function(Map<String, dynamic>?)? onChanged;
  final String? keyDisplay;
  final Map<String, dynamic>? currentValue;
  const RDropDown({
    Key? key,
    required this.label,
    required this.items,
    required this.onChanged,
    required this.keyDisplay,
    this.hintText,
    this.currentValue,
  }) : super(key: key);

  @override
  State<RDropDown> createState() => _RDropDownState();
}

class _RDropDownState extends State<RDropDown> {
  Map<String, dynamic>? selectedvalue;
  bool initList = false;
  bool loadedCurrentValue = false;
  List<DropdownMenuItem<Map<String, dynamic>?>> listItems = [];
  @override
  Widget build(BuildContext context) {
    if (!initList) {
      listItems.add(DropdownMenuItem<Map<String, dynamic>?>(
        value: null,
        child: RText(title: widget.hintText ?? '', type: RTextType.text, align: TextAlign.left, color: Colors.grey),
      ));
      listItems.addAll(List<DropdownMenuItem<Map<String, dynamic>?>>.generate(
          widget.items!.length,
          (index) => DropdownMenuItem<Map<String, dynamic>?>(
                value: widget.items![index],
                child: RText(
                  title: widget.items![index][widget.keyDisplay],
                  type: RTextType.text,
                  align: TextAlign.left,
                ),
              )));
      initList = true;
    }
    if (!loadedCurrentValue && widget.currentValue != null && selectedvalue == null) {
      selectedvalue = widget.items!.firstWhereOrDefault((value) => value['id'] == widget.currentValue!['id']);
      loadedCurrentValue = true;
    }
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        margin: const EdgeInsets.only(top: 7, bottom: 7),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.1),
            blurRadius: 3,
            spreadRadius: 0,
            //offset: Offset(-2,2)
          )
        ]),
        child: Stack(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: DropdownButtonHideUnderline(
                child: DropdownButton<Map<String, dynamic>?>(
                    iconSize: 0,
                    value: selectedvalue,
                    items: listItems,
                    onChanged: (value) {
                      widget.onChanged!(value);
                      setState(() {
                        selectedvalue = value;
                      });
                    }),
              )),
            ],
          ),
          RText(title: widget.label, type: RTextType.label, color: themeColor),
          const Positioned(
              top: 17,
              right: 5,
              child: Icon(
                FontAwesomeIcons.angleDown,
                size: 20,
                color: themeColor,
              ))
        ]));
  }
}
