import 'package:flutter/material.dart';

import '../color/theme.dart';
import '../r-text/title.dart';
import '../r-text/type.dart';

class RAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  const RAppBar({
    Key? key,
    required this.title,
    this.leading,
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
          color: themeColor,
        ),
      ),
      backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
      iconTheme: const IconThemeData(color: themeColor // <-- SEE HERE
          ),
      centerTitle: true,
      actions: [
        Container(padding: const EdgeInsets.all(6), child: Image.asset('lib/assets/images/main-logo.png')),
      ],
    );
  }
}
