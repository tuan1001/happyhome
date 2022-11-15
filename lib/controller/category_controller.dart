import 'package:flutter/material.dart';

import 'service_controller.dart';

Future<Map<String, dynamic>?> getBranchCategory({
  required BuildContext context,
}) async {
  Map<String, dynamic>? result;
  await getAPI(
    action: 'danh-sach-chi-nhanh',
    body: {
      'uid': '',
      'auth': '',
    },
    context: context,
  ).then((value) => ({
        result = value,
      }));
  return result;
}
