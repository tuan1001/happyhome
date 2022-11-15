import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showRToast({
  required String message,
  ToastType type = ToastType.success,
  ToastGravity gravity = ToastGravity.BOTTOM,
}) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: gravity,
    timeInSecForIosWeb: 1,
    backgroundColor: getBackgroundColor(type).withOpacity(0.8),
    textColor: Colors.black,
    fontSize: 16.0,
  );
}

Color getBackgroundColor(ToastType? type) {
  switch (type) {
    case ToastType.success:
      return Colors.green;
    case ToastType.danger:
      return Colors.red;
    case ToastType.warning:
      return Colors.orange;
    default:
      return Colors.grey;
  }
}

enum ToastType {
  normal,
  success,
  danger,
  warning,
}
