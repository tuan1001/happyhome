// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rcore/models/user.dart';
import 'package:rcore/utils/r-drawer/bottom_nav_bar.dart';
import 'package:rcore/utils/r-layout/appbar.dart';

import '../color/theme.dart';

class RSubLayout extends StatelessWidget {
  final User? user;
  final GlobalKey<ScaffoldState>? globalKey;
  final String? title;
  final List<Widget>? body;
  final Color? backgroundColor;
  final bool? overlayLoading;
  final Future<void> Function()? onRefresh;
  final EdgeInsetsGeometry? contenPadding;
  final int? bottomNavIndex;
  final bool? showBottomNavBar;
  const RSubLayout({
    Key? key,
    required this.globalKey,
    required this.title,
    required this.body,
    this.overlayLoading,
    this.bottomNavIndex,
    this.showBottomNavBar = true,
    this.onRefresh,
    this.backgroundColor,
    this.contenPadding,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Stack(
        children: [
          Scaffold(
            key: globalKey,
            resizeToAvoidBottomInset: true,
            extendBody: true,
            bottomNavigationBar: showBottomNavBar == true
                ? BottomNavBar(
                    index: bottomNavIndex,
                    user: user!,
                  )
                : Container(),
            appBar: RAppBar(
              title: title,
              leading: IconButton(
                icon: Icon(
                  FontAwesomeIcons.angleLeft,
                  color: themeColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            backgroundColor: backgroundColor ?? Color.fromRGBO(246, 246, 246, 1),
            body: RefreshIndicator(
              onRefresh: onRefresh ?? () async {},
              child: Container(
                color: backgroundColor ?? Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Expanded(
                      //Body
                      child: ListView(
                        padding: contenPadding ?? EdgeInsets.all(20),
                        children: body!,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (overlayLoading == true)
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
