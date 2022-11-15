import 'package:flutter/material.dart';
import 'package:rcore/models/user.dart';
import 'package:rcore/utils/r-drawer/bottom_nav_bar.dart';
import 'package:rcore/utils/r-layout/appbar.dart';

class RSubLayout extends StatelessWidget {
  final User? user;
  final GlobalKey<ScaffoldState>? globalKey;
  final String? title;
  final List<Widget>? body;
  final Color? backgroundColor;
  final bool? overlayLoading;
  final bool enableAction;
  final Future<void> Function()? onRefresh;
  final EdgeInsetsGeometry? contenPadding;
  final int? bottomNavIndex;
  final bool? showBottomNavBar;
  final bool extendBody;
  final Widget? floatingActionButton;
  final AppBar? appBar;
  const RSubLayout({
    Key? key,
    required this.globalKey,
    required this.body,
    this.title,
    this.overlayLoading,
    this.bottomNavIndex,
    this.showBottomNavBar = true,
    this.onRefresh,
    this.backgroundColor,
    this.contenPadding,
    this.user,
    this.appBar,
    this.extendBody = false,
    this.floatingActionButton,
    this.enableAction = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget tmp = Scaffold(
      key: globalKey,
      resizeToAvoidBottomInset: true,
      extendBody: extendBody,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showBottomNavBar == true
          ? BottomNavBar(
              index: bottomNavIndex,
              user: user!,
            )
          : Container(),
      appBar: appBar ?? RAppBar(title: title, enableAction: enableAction),
      backgroundColor: backgroundColor ?? Colors.white,
      body: RefreshIndicator(
        onRefresh: onRefresh ?? () async {},
        child: ListView(
          shrinkWrap: true,
          padding: contenPadding ?? const EdgeInsets.all(20),
          children: body!,
        ),
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: overlayLoading != true
          ? tmp
          : Stack(
              children: [
                tmp,
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: const [
                      Opacity(
                        opacity: 0.8,
                        child: ModalBarrier(dismissible: false, color: Colors.black),
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
