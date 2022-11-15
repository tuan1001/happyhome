import 'package:flutter/material.dart';
import 'package:rcore/utils/r-text/type.dart';

import '../color/theme.dart';
import '../r-text/title.dart';

void showDDiaLog(
  BuildContext context, {
  List<Widget>? body,
  List<Widget>? actions,
  required String title,
}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 0,
          actionsPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          contentPadding: const EdgeInsets.all(10),
          titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          buttonPadding: const EdgeInsets.all(10),
          insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: RText(
            title: title,
            type: RTextType.subtitle,
            color: themeColor,
            alignment: Alignment.center,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: body!,
            ),
          ),
          actions: actions,
        );
      });
}
