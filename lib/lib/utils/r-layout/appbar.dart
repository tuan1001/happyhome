import 'package:flutter/material.dart';

import '../color/theme.dart';
import '../r-text/title.dart';
import '../r-text/type.dart';

class RAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool enableAction;
  const RAppBar({
    Key? key,
    required this.title,
    this.enableAction = false,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Align(
        alignment: Alignment.center,
        child: RText(
          title: title!.toUpperCase(),
          type: RTextType.header1,
          color: Colors.white,
        ),
      ),
      backgroundColor: themeColor,
      iconTheme: const IconThemeData(color: Colors.white),
      centerTitle: true,
      actions: [
        // Container(padding: const EdgeInsets.all(6), child: Image.asset('lib/assets/images/main-logo.png')),
        if (enableAction) const SizedBox(width: 55),
      ],
    );
  }
}
