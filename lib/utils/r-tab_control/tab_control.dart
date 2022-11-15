// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rcore/utils/color/theme.dart';
import 'package:rcore/utils/r-tab_control/tab_content.dart';
import 'package:rcore/utils/r-tab_control/tab_header.dart';

class RTabControl extends StatefulWidget {
  final List<RTabHeader>? headers;
  final List<RTabContent>? contents;
  const RTabControl({Key? key, required this.headers, required this.contents}) : super(key: key);

  @override
  State<RTabControl> createState() => _RTabControlState();
}

class _RTabControlState extends State<RTabControl> {
  // final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> listHeader = [];
    for (var item in widget.headers!) {
      int index = widget.headers!.indexWhere((element) => element == item);
      if (index != selectedTab) {
        listHeader.add(Container(
          constraints: BoxConstraints(
              minWidth: (MediaQuery.of(context).size.width - 40) / widget.headers!.length,
              maxWidth: (MediaQuery.of(context).size.width - 40) / widget.headers!.length),
          margin: (EdgeInsets.only(left: (MediaQuery.of(context).size.width - 40) / widget.headers!.length * index)),
          decoration: BoxDecoration(
            color: Color.fromRGBO(
                255 - ((index - selectedTab).abs() * 5), 255 - ((index - selectedTab).abs() * 5), 255 - ((index - selectedTab).abs() * 5), 1),
          ),
          child: TextButton(
            onPressed: () {
              setState(() {
                selectedTab = index;
              });
            },
            child: item,
          ),
        ));
      }
    }
    listHeader.add(Container(
      constraints: BoxConstraints(minWidth: (MediaQuery.of(context).size.width - 40) / widget.headers!.length),
      clipBehavior: Clip.none,
      margin: (EdgeInsets.only(left: (MediaQuery.of(context).size.width - 40) / widget.headers!.length * selectedTab)),
      //padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255 - ((selectedTab - selectedTab).abs() * 5), 255 - ((selectedTab - selectedTab).abs() * 5),
              255 - ((selectedTab - selectedTab).abs() * 5), 1),
          // border: Border(
          //   top: BorderSide(color: themeBorderColor),
          //   left: BorderSide(color: themeBorderColor),
          //   right: BorderSide(color: themeBorderColor),
          // ),
          boxShadow: [
            BoxShadow(
              color: themeColor.withOpacity(0.1),
              blurRadius: 3,
              spreadRadius: 0,
              //offset: Offset(-2,2)
            )
          ]),
      child: TextButton(
        onPressed: () {},
        child: widget.headers!.elementAt(selectedTab),
      ),
    ));
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Stack(
              children: listHeader,
            ),
            widget.contents!.elementAt(selectedTab)
          ],
        ));
  }
}
