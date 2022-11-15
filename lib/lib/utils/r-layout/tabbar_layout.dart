import 'package:flutter/material.dart';
import 'package:rcore/utils/color/theme.dart';

import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/utils/r-text/type.dart';

import '../../models/user.dart';
import '../r-drawer/bottom_nav_bar.dart';
import 'tab_bar_view_item.dart';
import 'tabbar.dart';

class RTabBarLayout extends StatefulWidget {
  final User? user;

  final List<Tab> tabs;
  final List<RTabBarViewItem> screens;
  final GlobalKey<ScaffoldState>? globalKey;
  final String? title;
  final Widget? bottomDrawer;
  final bool? bottomDrawerShow;
  final bool? overlayLoading;
  final ScrollController? scrollController;
  final FloatingActionButton? floatingActionButton;
  final Function(int)? onTabChange;
  final int? bottomNavIndex;
  final bool? showBottomNavBar;

  const RTabBarLayout({
    Key? key,
    required this.user,
    required this.tabs,
    required this.screens,
    required this.globalKey,
    required this.title,
    this.bottomDrawer,
    this.bottomDrawerShow,
    this.overlayLoading,
    this.scrollController,
    this.floatingActionButton,
    this.onTabChange,
    this.bottomNavIndex,
    this.showBottomNavBar,
  }) : super(key: key);

  @override
  State<RTabBarLayout> createState() => _RTabBarLayoutState();
}

class _RTabBarLayoutState extends State<RTabBarLayout> with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
      length: widget.tabs.length,
    );
    tabController.addListener(() {
      if (widget.onTabChange != null) {
        widget.onTabChange!(tabController.index);
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Scaffold(
              key: widget.globalKey,
              resizeToAvoidBottomInset: true,
              bottomNavigationBar: widget.showBottomNavBar == true
                  ? BottomNavBar(
                      index: widget.bottomNavIndex,
                      user: widget.user!,
                    )
                  : Container(),
              appBar: AppBar(
                shadowColor: Colors.transparent,
                leading: Container(width: 50),
                title: RText(
                  alignment: Alignment.center,
                  title: widget.title!.toUpperCase(),
                  type: RTextType.header1,
                  color: Colors.white,
                ),
                actions: [Container(width: 50)],
                centerTitle: true,
                bottom: RTabBar(controller: tabController, tabs: widget.tabs),
                backgroundColor: themeColor,
                iconTheme: const IconThemeData(color: themeColor),
              ),
              backgroundColor: const Color(0xFFF8F8F8),
              body: TabBarView(
                controller: tabController,
                children: [...widget.screens],
              ),
              floatingActionButton: widget.floatingActionButton,
            ),
            if (widget.overlayLoading == true)
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
        ));
  }
}
