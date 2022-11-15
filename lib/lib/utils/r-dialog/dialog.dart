import 'package:flutter/material.dart';
import 'package:rcore/utils/color/theme.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/utils/r-text/type.dart';

void showRDiaLog(
  BuildContext context,
  List<Widget> body, {
  bool isButtonDissmiss = false,
}) {
  showDialog(
    anchorPoint: const Offset(0.5, 0.5),
    routeSettings: const RouteSettings(name: 'RDiaLog'),
    useRootNavigator: false,
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // padding: EdgeInsets.all(10),
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
                    children: body,
                  ),
                ),
                if (isButtonDissmiss == true)
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        top: BorderSide(color: themeColor, width: 1),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Center(
                          child: RText(
                        alignment: Alignment.center,
                        title: 'OK',
                        color: themeColor,
                        type: RTextType.subtitle,
                      )),
                    ),
                  )
              ],
            ),
            //
          ),
        ],
      ),
    ),
  );
}
