// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rcore/const/api_const.dart';
import 'package:rcore/utils/r-dialog/notification_dialog.dart';
import 'package:rcore/utils/r-navigator/navigator.dart';
import 'package:rcore/views/landing/landing_screen.dart';

Future<Map<String, dynamic>?> getAPI({
  String controller = 'restful-api',
  required String action,
  required Map<String, dynamic> body,
  required BuildContext context,
  Map<String, dynamic>? files,
}) async {
  String currentTimeStamp = (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();
  var fromData = FormData();
  body.forEach((key, value) {
    //print("KEY: ${key}");
    fromData.fields.add(MapEntry(key, dynamicNullValidate(value)));
  });
  if (files != null) {
    files.forEach((key, value) {
      fromData.files.add(MapEntry(key, value));
    });
  }
  debugPrint('DATA: ${fromData.fields}');
  debugPrint('URL: ${getUrl(baseUrl, controller, action)}&timestamp=$currentTimeStamp');
  var response = await Dio().post('${getUrl(baseUrl, controller, action)}&timestamp=$currentTimeStamp', data: fromData,
      options: Options(validateStatus: (status) {
    if (status != null) {
      return status <= 500;
    } else {
      return false;
    }
  }));
  debugPrint('RESPONSE: ${response.data}');
  if (response.data is! Map<String, dynamic>) {
    showRNotificationDialog(context, 'Thông báo', 'Lỗi không xác định');
    return null;
  }
  switch (response.statusCode) {
    case 500:
      showRNotificationDialog(context, 'Thông báo', response.data['message']);
      return null;
    case 401:
      var prefs = await SharedPreferences.getInstance();
      prefs.remove('SAVED_USER');
      prefs.remove('SAVED_PASS');
      showRNotificationDialog(context, 'Thông báo', response.data['message']);
      newScreen(const LandingScreen(), context);
      return null;
    default:
      return response.data;
  }
}

String getUrl(String baseUrl, String controller, String action) {
  return baseUrl.replaceAll('__CONTROLLER__', controller).replaceAll('__ACTION__', action);
}

Future<void> saveToFile(String key, String value, BuildContext context) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/3.dat';
    final file = File(path);
    if (file.existsSync()) {
      final String data = await file.readAsString();
      Map<String, dynamic> json = jsonDecode(data);
      json[key] = value;
      debugPrint(jsonEncode(json));
      file.writeAsString(jsonEncode(json));
    } else {
      Map<String, dynamic> json = {};
      json[key] = value;
      debugPrint(jsonEncode(json));
      file.writeAsString(jsonEncode(json));
    }
  } catch (e) {
    showRNotificationDialog(context, 'Thông báo', e.toString());
  }
}

Future<String> getFromFile(String key, BuildContext context) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/3.dat';
    final file = File(path);
    final String data = await file.readAsString();
    debugPrint(data);
    Map<String, dynamic> json = jsonDecode(data);
    return json[key];
  } catch (e) {
    return "";
  }
}

Future<void> deleteFile(BuildContext context) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/3.dat';
    final file = File(path);
    await file.delete();
  } catch (e) {
    rethrow;
  }
}

Future<String?> imageSelection() async {
  XFile? pickedFile = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxWidth: 1800,
    maxHeight: 1800,
  );
  return pickedFile?.path;
}

Future<String?> imageTaking() async {
  XFile? pickedFile = await ImagePicker().pickImage(
    source: ImageSource.camera,
    maxWidth: 1800,
    maxHeight: 1800,
  );
  return pickedFile?.path;
}

String stringNullValidate(String? str) {
  return str ?? '';
}

int intNullValidate(int? x) {
  return x ?? 0;
}

double doubleNullValidate(double? x) {
  return x ?? 0;
}

String stringValueIfEmpty(String? str, String value) {
  return str == null || str.isEmpty ? value : str;
}

int intValueIfEmpty(int? number, int value) {
  return number ?? value;
}

String numberFormatCurrency(dynamic str) {
  try {
    if (str != null) {
      if (str is String) {
        return NumberFormat().format(double.parse(str));
      } else if (str is int) {
        return NumberFormat().format(double.parse(str.toString()));
      } else {
        return NumberFormat().format(str);
      }
    } else {
      return '';
    }
  } catch (e) {
    return '';
  }
}

int commaValidate(String? str) {
  if (str == null || str.isEmpty || !(str.contains(','))) {
    return 0;
  } else {
    return int.parse(str.replaceAll(',', ''));
  }
}

double dynamicToDouble(dynamic value) {
  try {
    return double.parse(value.toString());
  } catch (e) {
    return 0;
  }
}

int dynamicToInt(dynamic value) {
  try {
    return int.parse(value.toString());
  } catch (e) {
    return 0;
  }
}

String dynamicNullValidate(dynamic value) {
  return value == null ? '' : value.toString();
}

extension CustomExtensionString on String {
  int strToInt() {
    try {
      return int.parse(this);
    } catch (e) {
      return 0;
    }
  }
}
