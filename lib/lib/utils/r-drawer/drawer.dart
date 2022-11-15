// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:rcore/utils/r-drawer/drawer_header.dart';

class RDrawer extends StatelessWidget {
  final RDrawerHeader? header;
  final List<Widget>? items;
  const RDrawer({
    Key? key,
    required this.header,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
          children: <Widget>[
                header!,
              ] +
              (items != null ? items! : [])),
    );
  }
}
