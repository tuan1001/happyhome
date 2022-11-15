// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class RDrawerHeader extends StatelessWidget {
  final List<Widget>? content;
  const RDrawerHeader({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
          // color: Color.fromRGBO(255, 183, 82, 1),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: const [
              Color.fromRGBO(255, 249, 90, 1),
              // Color.fromRGBO(255, 197, 50, 1),
              // Color.fromRGBO(255, 190, 25, 1),
              Color.fromRGBO(255, 148, 16, 1),
            ],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/images/main-logo.png'))),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: content!,
              ),
            ),
          ],
        ));
  }
}
