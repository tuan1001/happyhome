import 'package:flutter/material.dart';
import 'package:rcore/controller/service_controller.dart';

import '../models/user.dart';

Future<Map<String, dynamic>?> loadListRequest({
  required BuildContext context,
  required User user,
  String? searchContent,
  String? fromDate,
  String? toDate,
  int? page,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'danh-sach-phan-hoi',
    body: {
      'uid': user.id,
      'auth': user.authKey,
      'tuKhoa': searchContent,
      'tuNgay': fromDate ?? '',
      'denNgay': toDate ?? '',
      'perPage': page ?? 1,
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}

Future<Map<String, dynamic>?> loadRequestDetail({
  required BuildContext context,
  required User user,
  required int id,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'chi-tiet-phan-hoi',
    body: {
      'uid': user.id,
      'auth': user.authKey,
      'id': id,
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}

Future<Map<String, dynamic>?> addRequest({
  required BuildContext context,
  required User user,
  required String title,
  required String requestContent,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'save-phan-hoi',
    body: {
      'uid': user.id,
      'auth': user.authKey,
      'title': title,
      'noi_dung': requestContent,
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}

Future<Map<String, dynamic>?> replyAdminRequest({
  required BuildContext context,
  required User user,
  required int id,
  required String replyContent,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'phan-hoi-quan-ly-ctv',
    body: {
      'uid': user.id,
      'auth': user.authKey,
      'id': id,
      'noi_dung': replyContent,
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}

Future<Map<String, dynamic>?> updateRequest({
  required BuildContext context,
  required User user,
  required int id,
  required String title,
  required String requestContent,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'sua-phan-hoi',
    body: {
      'uid': user.id,
      'auth': user.authKey,
      'title': title,
      'noi_dung': requestContent,
      'id': id,
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}

Future<Map<String, dynamic>?> deleteRequest({
  required BuildContext context,
  required User user,
  required int id,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'xoa-phan-hoi',
    body: {
      'uid': user.id,
      'auth': user.authKey,
      'id': id,
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}

Future<Map<String, dynamic>?> deleteReply({
  required BuildContext context,
  required User user,
  required int id,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'xoa-phan-hoi',
    body: {
      'uid': user.id,
      'auth': user.authKey,
      'id': id,
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}

Future<Map<String, dynamic>?> closeRequest({
  required BuildContext context,
  required User user,
  required int id,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'dong-phan-hoi',
    body: {
      'uid': user.id,
      'auth': user.authKey,
      'id': id,
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}
