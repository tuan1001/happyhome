import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rcore/utils/r-text/icon_text.dart';
import 'package:rcore/utils/r-text/type.dart';

import '../color/theme.dart';

class RCoinItem extends StatelessWidget {
  final Map<String, dynamic>? data;
  const RCoinItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: themeColor.withOpacity(0.1),
          blurRadius: 3,
          spreadRadius: 0,
          //offset: Offset(-2,2)
        )
      ]),
      child: Column(
        children: [
          RIconText(
            title: data!['created'] ?? '',
            icon: FontAwesomeIcons.calendarDays,
            type: RTextType.title,
            color: themeColor,
          ),
          Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: themeColor.withOpacity(0.1),
                  blurRadius: 3,
                  spreadRadius: 0,
                  //offset: Offset(-2,2)
                )
              ]),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RIconText(title: '${data!['loai_tich_xu'] ?? ''}', icon: FontAwesomeIcons.solidUser),
                          RIconText(
                            title: NumberFormat().format(double.parse(data!['so_xu'].toString())),
                            icon: FontAwesomeIcons.coins,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                      RIconText(
                        width: MediaQuery.of(context).size.width - 105,
                        title: '${data!['noi_dung_tich_xu'] ?? ''}',
                        icon: FontAwesomeIcons.solidNoteSticky,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              )),
        ],
      ),
    );
  }
}
