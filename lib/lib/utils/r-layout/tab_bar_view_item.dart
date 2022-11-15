import 'package:flutter/material.dart';

class RTabBarViewItem extends StatelessWidget {
  final List<Widget> body;
  final ScrollController? scrollController;
  final Widget? bottomDrawer;
  final bool? bottomDrawerShow;
  final Future<void> Function()? onRefresh;
  const RTabBarViewItem({Key? key, required this.body, this.scrollController, this.bottomDrawer, this.bottomDrawerShow, this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            margin: EdgeInsets.zero,
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              Expanded(
                //Body
                child: RefreshIndicator(
                  onRefresh: onRefresh == null ? () async {} : onRefresh!,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: body,
                  ),
                ),
              ),
              bottomDrawer != null && bottomDrawerShow == true ? bottomDrawer! : Container(),
            ])),
      ],
    );
  }
}
