import 'package:flutter/material.dart';
import 'package:rcore/controller/service_controller.dart';

import '../models/user.dart';

Future<Map<String, dynamic>?> getListTranningVideo({
  required BuildContext context,
  required User userInfo,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'list-video',
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

Future<Map<String, dynamic>?> getListTranningFile({
  required BuildContext context,
  required User userInfo,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'list-tai-lieu',
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
