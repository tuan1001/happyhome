// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rcore/utils/r-text/icon_text.dart';
import 'package:rcore/utils/r-text/type.dart';

import '../../controller/service_controller.dart';
import '../color/theme.dart';
import '../r-text/title.dart';

class RRoseItem extends StatelessWidget {
  final Map<String, dynamic>? data;
  const RRoseItem({Key? key, required this.data}) : super(key: key);

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
            title: 'Giao dịch ngày ${data!['date']}',
            icon: FontAwesomeIcons.calendarDays,
            type: RTextType.title,
            color: themeColor,
          ),
          const Divider(),
          ...List<Widget>.generate(
            data!['data'].length,
            (index) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RIconText(title: data!['data'][index]['hoten'], icon: FontAwesomeIcons.solidUser, type: RTextType.subtitle),
                RText(title: '${numberFormatCurrency(data!['data'][index]['hoa_hong'] ?? 0)} Triệu', type: RTextType.subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
