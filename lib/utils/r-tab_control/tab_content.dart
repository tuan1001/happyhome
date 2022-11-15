// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../color/theme.dart';

class RTabContent extends StatelessWidget {
  final List<Widget>? body;
  const RTabContent({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: themeColor.withOpacity(0.1),
          blurRadius: 3,
          spreadRadius: 0,
          //offset: Offset(-2,2)
        )
      ]),
      child: Column(
        children: body!,
      ),
    );
  }
}
