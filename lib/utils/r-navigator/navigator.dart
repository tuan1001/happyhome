import 'package:flutter/material.dart';

Future<void> toScreen(Widget screen, BuildContext context) async {
  await Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
}

Future<void> replaceScreen(Widget screen, BuildContext context) async {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => screen));
}

Future<void> newScreen(Widget screen, BuildContext context) async {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => screen),
    (route) => false,
  );
}
