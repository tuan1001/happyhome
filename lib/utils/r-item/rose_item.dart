// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rcore/utils/r-text/icon_text.dart';
import 'package:rcore/utils/r-text/type.dart';

import '../color/theme.dart';

class RRoseItem extends StatelessWidget {
  final Map<String, dynamic>? data;
  const RRoseItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
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
            title: data!['ngay_cong_chung'] ?? '',
            icon: FontAwesomeIcons.calendarDays,
            type: RTextType.title,
            color: themeColor,
          ),
          Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 5),
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
                      RIconText(title: '${data!['khach_hang'] ?? ''}', icon: FontAwesomeIcons.solidUser),
                      Row(
                        children: [
                          RIconText(
                            width: MediaQuery.of(context).size.width - 135,
                            title: '${data!['title'] ?? ''}',
                            icon: FontAwesomeIcons.house,
                          ),
                          Spacer(),
                          // data!['trang_thai'] == 'Đã xác minh'
                          //     ? Icon(FontAwesomeIcons.circleCheck, color: Colors.green)
                          //     : Icon(FontAwesomeIcons.arrowsRotate, color: Colors.grey),
                          Icon(FontAwesomeIcons.circleCheck, color: Colors.green),
                          //     : Icon(FontAwesomeIcons.arrowsRotate, color: Colors.grey),
                          // Icon(FontAwesomeIcons.arrowsRotate, color: Colors.grey)
                        ],
                      ),
                      RIconText(
                        title: NumberFormat().format(double.parse(data!['hoa_hong'].toString())),
                        icon: FontAwesomeIcons.dollarSign,
                        // color: data!['trang_thai'] == 'Đã xác minh' ? Colors.orange : Colors.grey,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  Divider(),
                ],
              )),
        ],
      ),
    );
  }
}
