import 'package:flutter/material.dart';

import 'package:rcore/utils/r-dialog/notification_dialog.dart';

import '../models/user.dart';
import 'service_controller.dart';

Future<Map<String, dynamic>?> login({
  required BuildContext context,
  required String username,
  required String password,
  required String deviceToken,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'login',
    body: {
      'username': username,
      'password': password,
      'device_token': deviceToken,
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}

Future<Map<String, dynamic>?> register({
  required BuildContext context,
  required String phone,
  required String password,
  required String name,
  required String invitedCode,
  required String branchID,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'dang-ki',
    body: {
      'dien_thoai': phone,
      'password': password,
      'hoten': name,
      'parent_so_dien_thoai': invitedCode,
      'chi_nhanh_id': branchID,
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}

Future<Map<String, dynamic>?> forgotPassword({
  required BuildContext context,
  required String phone,
}) async {
  if (phone.isEmpty) {
    showRNotificationDialog(context, 'Thông báo', 'Vui lòng điền email đăng ký của bạn!');
    return null;
  }
  Map<String, dynamic>? result;
  await getAPI(
    action: 'quen-mat-khau',
    body: {
      'dien_thoai': phone,
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}

Future<Map<String, dynamic>?> checkOtp({
  required BuildContext context,
  required String email,
  required String keyOtp,
}) async {
  if (keyOtp.isEmpty) {
    showRNotificationDialog(context, 'Thông báo', 'Vui lòng điền mã xác thực!');
    return null;
  }
  Map<String, dynamic>? result;
  await getAPI(
    action: 'check-otp',
    body: {
      'email': email,
      'key_otp': keyOtp,
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}

Future<Map<String, dynamic>?> changeUserPassword({
  required BuildContext context,
  required User userInfo,
  required String oldPassword,
  required String newPassword,
}) async {
  if (newPassword.isEmpty) {
    showRNotificationDialog(context, 'Thông báo', 'Vui lòng điền mật khẩu mới!');
    return null;
  } else if (newPassword.length < 6 || newPassword.length > 32) {
    showRNotificationDialog(context, 'Thông báo', 'Mật khẩu ít nhất 8 ký tự và tối đa 32 ký tự!');
  }
  if (newPassword.isEmpty) {
    showRNotificationDialog(context, 'Thông báo', 'Vui lòng điền mật khẩu xác nhận!');
    return null;
  }
  Map<String, dynamic>? result;
  await getAPI(
    action: 'doi-mat-khau',
    body: {
      'uid': userInfo.id,
      'auth': userInfo.authKey,
      'passwordOld': oldPassword,
      'passwordNew': newPassword,
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}

Future<User?> getUserInfo({
  required BuildContext context,
  required int uid,
  required String auth,
  //required Map<String, dynamic> userInfo,
}) async {
  User? result;
  await getAPI(controller: 'services', action: 'load-user', body: {'uid': uid, 'auth': auth, 'id': uid}, context: context).then((value) => ({
        result = User.fromMap(value!),
      }));
  return result;
}
