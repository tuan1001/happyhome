import 'package:flutter/material.dart';

import '../color/theme.dart';

class RTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController? controller;
  final List<Tab> tabs;
  const RTabBar({
    Key? key,
    required this.controller,
    required this.tabs,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          const BoxDecoration(color: Color(0xFFEFEFEF), borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: TabBar(
        controller: controller,
        tabs: tabs,
        labelColor: themeColor,
        unselectedLabelColor: Colors.black,
        //overlayColor: MaterialStateProperty.all(Color.fromRGBO(239, 239, 239, 1)),
      ),
    );
  }
}
