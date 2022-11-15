import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rcore/models/user.dart';
import 'package:rcore/utils/color/theme.dart';
import 'package:rcore/utils/r-navigator/navigator.dart';
import 'package:rcore/views/request/request_screen.dart';

import 'package:rcore/views/statistical/main_statistical.dart';
import 'package:rcore/views/rose/rose_screen.dart';
import 'package:rcore/views/customer/customer_screen.dart';
import 'package:rcore/views/system/system_screen.dart';

class BottomNavBar extends StatefulWidget {
  final User user;
  final int? index;
  const BottomNavBar({
    Key? key,
    this.index = 0,
    required this.user,
  }) : super(key: key);

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  var currentIndex = 0;

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.settings_rounded,
    Icons.person_rounded,
  ];
  List<dynamic> listOfPages = [];

  @override
  void initState() {
    listOfPages = [
      {
        'icon': 'house',
        'pageRoute': MainStatisticalScreen(user: widget.user),
      },
      {
        'icon': 'users',
        'pageRoute': CustomerScreen(user: widget.user),
      },
      {
        'icon': 'dolar',
        'pageRoute': RoseScreen(user: widget.user),
      },
      {
        'icon': 'message',
        'pageRoute': RequestScreen(user: widget.user),
      },
      {
        'icon': 'setting',
        'pageRoute': SystemScreen(user: widget.user),
      },
    ];
    currentIndex = widget.index ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: size.width * .155,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
        // borderRadius: BorderRadius.circular(50),
      ),
      child: ListView.builder(
        itemCount: listOfPages.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            if (currentIndex == index) return;
            newScreen(listOfPages[index]['pageRoute'], context);
            setState(
              () {
                currentIndex = index;
              },
            );
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 1500),
                curve: Curves.fastLinearToSlowEaseIn,
                margin: EdgeInsets.only(
                  bottom: index == currentIndex ? 0 : size.width * .029,
                  right: size.width * .04,
                  left: size.width * .04,
                ),
                width: size.width * .12,
                height: index == currentIndex ? size.width * .014 : 0,
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.9),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                ),
              ),
              // Icon(
              //   listOfPages[index]['icon'],
              //   size: size.width * .076,
              //   color: index == currentIndex ? themeColor.withOpacity(0.9) : Colors.black38,
              // ),
              SvgPicture.asset(
                'lib/assets/icons/${listOfPages[index]['icon']}.svg',
                width: size.width * .076,
                height: size.width * .076,
                color: index == currentIndex ? themeColor.withOpacity(0.9) : Colors.black38,
              ),
              SizedBox(height: size.width * .03),
            ],
          ),
        ),
      ),
    );
  }
}
