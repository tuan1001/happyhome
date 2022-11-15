import 'package:flutter/material.dart';
import 'package:rcore/models/user.dart';

import 'service_controller.dart';

Future<Map<String, dynamic>?> getListRequestCustomer({
  required BuildContext context,
  required User user,
  required int page,
  String? keySearch,
  String? active,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'get-list-khach-hang-ctv',
    body: {
      'uid': user.id,
      'auth': user.authKey,
      'page': page,
      'tuKhoa': keySearch,
      'trang_thai': active,
    },
    context: context,
  ).then(
    (value) => ({
      result = value,
    }),
  );
  return result;
}

Future<Map<String, dynamic>?> getRequestCoinCustomer({
  required BuildContext context,
  required User user,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'get-dollar',
    body: {
      'uid': user.id,
      'auth': user.authKey,
    },
    context: context,
  ).then(
    (value) => ({
      result = value,
    }),
  );
  return result;
}

Future<Map<String, dynamic>?> getRequestCustomerDetail({
  required BuildContext context,
  required User user,
  required int id,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'lich-su-trang-thai',
    body: {
      'uid': user.id,
      'auth': user.authKey,
      'id': id,
    },
    context: context,
  ).then(
    (value) => ({
      result = value,
    }),
  );
  return result;
}

Future<Map<String, dynamic>?> createRequestCustomer({
  required BuildContext context,
  required User userInfo,
  required String? name,
  required String? phone,
  required String? note,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'tao-moi-khach-hang-ctv',
    body: {
      'uid': userInfo.id,
      'auth': userInfo.authKey,
      'ho_ten': name,
      'dien_thoai': phone,
      'ghi_chu': note,
    },
    context: context,
  ).then(
    (value) => ({
      result = value,
    }),
  );
  return result;
}

Future<Map<String, dynamic>?> updateRequestCustomerInfo({
  required BuildContext context,
  required User userInfo,
  required int? id,
  required String? name,
  required String? phone,
  required String? note,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'sua-khach-hang',
    body: {
      'uid': userInfo.id,
      'auth': userInfo.authKey,
      'id': id,
      'ho_ten': name,
      'dien_thoai': phone,
      'ghi_chu': note,
    },
    context: context,
  ).then(
    (value) => ({
      result = value,
    }),
  );
  return result;
}

Future<Map<String, dynamic>?> updateDetailsRequestCustomerInfo({
  required BuildContext context,
  required User userInfo,
  required int? id,
  required String? name,
  required String? phone,
  required String? note,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'sua-chi-tiet-khach-hang',
    body: {
      'uid': userInfo.id,
      'auth': userInfo.authKey,
      'id': id,
      'ho_ten': name,
      'dien_thoai': phone,
      'ghi_chu': note,
    },
    context: context,
  ).then(
    (value) => ({
      result = value,
    }),
  );
  return result;
}

Future<Map<String, dynamic>?> deleteRequestCustomer({
  required BuildContext context,
  required User user,
  required int id,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'xoa-khach-hang',
    body: {
      'uid': user.id,
      'auth': user.authKey,
      'id': id,
    },
    context: context,
  ).then(
    (value) => ({
      result = value,
    }),
  );
  return result;
}
