// ignore_for_file: prefer_const_constructors, prefer_if_null_operators

import 'package:flutter/material.dart';

class RBottomDrawer extends StatelessWidget {
  final List<Widget>? body;
  final BoxDecoration? customize;
  final bool? greyFaded;
  final double? height;
  const RBottomDrawer({Key? key, required this.body, this.customize, this.greyFaded, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: customize != null
          ? customize
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 3, offset: Offset(0, -3))]),
      child: Column(
        children: body!,
      ),
    );
  }
}
