import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';

import '../models/user.dart';
import 'service_controller.dart';

Future<Map<String, dynamic>?> getUserRose({
  required BuildContext context,
  required User userInfo,
  String? fromDate,
  String? toDate,
  int page = 1,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'get-rose',
    body: {
      'uid': userInfo.id,
      'auth': userInfo.authKey,
      'tuNgay': fromDate ?? '',
      'denNgay': toDate ?? '',
      'page': page,
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}

Future<Map<String, dynamic>?> updateUserInfo({
  required BuildContext context,
  required User userInfo,
  String? name,
  String? avatarBase64,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'update-info',
    body: {
      'uid': userInfo.id,
      'auth': userInfo.authKey,
      'ho_ten': name ?? '',
      'avatar': avatarBase64 == '' ? '' : base64Encode(File(avatarBase64!).readAsBytesSync()),
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}

Future<Map<String, dynamic>?> deactiveUserAccount({
  required BuildContext context,
  required User userInfo,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'tu-sat',
    body: {
      'uid': userInfo.id,
      'auth': userInfo.authKey,
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}

Future<Map<String, dynamic>?> userLogOut({
  required BuildContext context,
  required User userInfo,
  required String deviceToken,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'logout',
    body: {
      'uid': userInfo.id,
      'auth': userInfo.authKey,
      'tokenDevice': deviceToken,
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}

Future<Map<String, dynamic>?> getUserStatistial({
  required BuildContext context,
  required User userInfo,
  String? fromDate,
  String? toDate,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'thong-ke-khach-hang-theo-thang',
    body: {
      'uid': userInfo.id,
      'auth': userInfo.authKey,
      'tuThang': fromDate ?? '',
      'denThang': toDate ?? '',
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}
