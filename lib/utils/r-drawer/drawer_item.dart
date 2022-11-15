import 'package:flutter/material.dart';

import '../color/theme.dart';

class RDrawerItem extends StatelessWidget {
  final IconData? icon;
  final bool? active;
  final String? title;
  final Widget? targetScreen;
  final Function()? customFunction;
  const RDrawerItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.active,
    required this.targetScreen,
    this.customFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: active == true ? themeColor : Colors.black),
      title: Text(title!, style: TextStyle(fontSize: 16, color: active == true ? themeColor : Colors.black)),
      // ignore: prefer_if_null_operators
      onTap: customFunction != null
          ? customFunction
          : (active != true
              ? () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => targetScreen!)));
                }
              : () {}),
    );
  }
}
