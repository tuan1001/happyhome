// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:rcore/utils/color/theme.dart';
import 'package:rcore/utils/r-text/text_superscript.dart';
import 'package:rcore/utils/r-text/type.dart';
import 'package:rcore/utils/r-textfield/type.dart';

import '../r-dialog/dialog.dart';

class RTextField extends StatefulWidget {
  final String? label;
  final String? labelsuperscript;
  final TextEditingController? controller;
  final Color? color;
  final Color? backColor;
  final int? type;
  final int? maxLength;
  final bool readOnly;
  final double? borderRadius;
  final IconData? prefixIcon;
  final double? prefixIconSize;
  final bool? alwaysActive;
  final Function()? onChanged;
  final Function(String)? onTextChange;
  final DateRangePickerView datePickerType;
  final Function()? onDateConfirm;
  final Function()? onDateRemove;
  final String customDateFormat;

  const RTextField({
    Key? key,
    required this.label,
    this.labelsuperscript,
    required this.controller,
    this.color,
    this.backColor,
    this.type,
    this.maxLength,
    this.readOnly = false,
    this.borderRadius,
    this.prefixIcon,
    this.prefixIconSize,
    this.alwaysActive,
    this.onChanged,
    this.onTextChange,
    this.datePickerType = DateRangePickerView.month,
    this.onDateConfirm,
    this.onDateRemove,
    this.customDateFormat = 'dd/MM/yyyy',
  }) : super(key: key);

  @override
  State<RTextField> createState() => _RTextFieldState();
}

class _RTextFieldState extends State<RTextField> {
  final DateRangePickerController _dateRangePickerController = DateRangePickerController();

  TextInputType getInputType() {
    switch (widget.type) {
      case RTextFieldType.password:
        return TextInputType.visiblePassword;
      case RTextFieldType.price:
      case RTextFieldType.number:
        return TextInputType.number;
      case RTextFieldType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 5),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 3,
          )
        ],
      ),
      child: TextField(
        readOnly: widget.readOnly,
        maxLength: widget.maxLength,
        onChanged: widget.type == RTextFieldType.price
            ? (value) {
                String str = value.replaceAll(',', '').isNotEmpty ? NumberFormat().format(double.parse(value.replaceAll(',', ''))) : '';
                widget.controller!.value = TextEditingValue(
                  text: str,
                  selection: TextSelection.collapsed(offset: str.length),
                );
              }
            : widget.onTextChange ?? (value) {},
        onTap: widget.type == RTextFieldType.date
            ? () {
                showRDiaLog(context, [
                  SfDateRangePicker(
                    controller: _dateRangePickerController,
                    selectionMode: DateRangePickerSelectionMode.single,
                    initialSelectedDate: DateTime.now(),
                    initialSelectedRange:
                        PickerDateRange(DateTime.now().subtract(const Duration(days: 4)), DateTime.now().add(const Duration(days: 3))),
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                      firstDayOfWeek: 1,
                    ),
                    showNavigationArrow: true,
                    allowViewNavigation: widget.datePickerType == DateRangePickerView.month,
                    view: widget.datePickerType,
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      todayTextStyle: const TextStyle(color: Colors.blue),
                      todayCellDecoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    onCancel: () {
                      widget.controller!.text = '';
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.onDateRemove == null ? null : widget.onDateRemove!();
                      Navigator.pop(context);
                    },
                    onSubmit: (date) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.controller!.text = DateFormat(widget.customDateFormat).format(_dateRangePickerController.selectedDate!);
                      widget.onDateConfirm == null ? null : widget.onDateConfirm!();
                      Navigator.pop(context);
                    },
                    onViewChanged: (dateRangePickerViewChangedArgs) {
                      debugPrint('View changed ${dateRangePickerViewChangedArgs.visibleDateRange}');
                    },
                    onSelectionChanged: (value) {
                      debugPrint('Selection changed ${value.value}');
                    },
                    showActionButtons: true,
                    showTodayButton: widget.datePickerType == DateRangePickerView.month,
                    minDate: DateTime(1900, 1, 1),
                    maxDate: DateTime(2100, 12, 31),
                    confirmText: 'Xác nhận',
                    cancelText: 'Hủy',
                  )
                ]);
              }
            : () {},
        onEditingComplete: widget.onChanged,
        maxLines: widget.type == RTextFieldType.multiline ? 5 : 1,
        controller: widget.controller,
        cursorColor: componentPrimaryColor,
        obscureText: widget.type == RTextFieldType.password,
        enableSuggestions: !(widget.type == RTextFieldType.password),
        autocorrect: !(widget.type == RTextFieldType.password),
        keyboardType: getInputType(),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: getInputType() == TextInputType.multiline ? 8 : 0),
          // hintText: label,
          label: RTextSupscript(
            title: widget.label,
            superscript: widget.labelsuperscript ?? '',
            type: RTextType.text,
            color: widget.color ?? themeColor,
          ),
          prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon, color: themeColor, size: widget.prefixIconSize ?? 15),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 5)),
          ),
          enabledBorder: widget.alwaysActive == true
              ? OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 5)),
                )
              : OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 5)),
                ),
          fillColor: widget.backColor ?? const Color.fromRGBO(250, 250, 250, 1),
          filled: true,
        ),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
    );
  }
}
