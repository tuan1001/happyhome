import 'package:flutter/material.dart';
import 'package:rcore/utils/r-dialog/dialog.dart';

import '../r-text/title.dart';
import '../r-text/type.dart';

void showRNotificationDialog(BuildContext context, String title, String content, {Function()? customFunction}) {
  showRDiaLog(
      context,
      [
        RText(
          title: title,
          type: RTextType.title,
          alignment: Alignment.center,
        ),
        RText(
          title: content,
          type: RTextType.text,
          alignment: Alignment.center,
        )
        // RTextButton(text: 'Đóng', onPressed: customFunction != null ? customFunction : () {
        //   Navigator.pop(context);
        // }, alignment: MainAxisAlignment.end,)
      ],
      isButtonDissmiss: true);
}
