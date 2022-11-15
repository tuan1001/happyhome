import 'package:flutter/material.dart';
import 'package:rcore/utils/r-button/text_button.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/utils/r-text/type.dart';

void showRYesNoDialog(
  BuildContext context,
  String title,
  String content,
  Function() onYes,
  Function() onNo, {
  bool isDialogPopYes = true,
  bool isDialogPopNo = true,
  String yesText = 'Có',
  String noText = 'Không',
}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            //padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      RText(
                        title: title,
                        type: RTextType.title,
                      ),
                      RText(
                        title: content,
                        type: RTextType.text,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RTextButton(
                              text: yesText,
                              onPressed: () {
                                onYes();
                                if (isDialogPopYes == true) Navigator.pop(context);
                              },
                              color: Colors.green),
                          RTextButton(
                              text: noText,
                              onPressed: () {
                                onNo();
                                if (isDialogPopNo) Navigator.pop(context);
                              },
                              color: Colors.red),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            //
          ),
        ],
      ),
    ),
  );
}
