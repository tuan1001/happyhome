import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rcore/bloc/user/bloc_user.dart';
import 'package:rcore/utils/color/theme.dart';
import 'package:rcore/utils/r-item/coin_item.dart';
import 'package:rcore/utils/r-item/rose_item.dart';
import 'package:rcore/utils/r-layout/tab_bar_view_item.dart';
import 'package:rcore/utils/r-layout/tabbar_layout.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/utils/r-text/type.dart';
import 'package:rcore/utils/r-textfield/textfield.dart';
import 'package:rcore/utils/r-textfield/type.dart';

import '../../models/user.dart';
import '../../utils/r-text/icon_text.dart';

class RoseScreen extends StatefulWidget {
  final User user;
  const RoseScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<RoseScreen> createState() => _RoseScreenState();
}

class _RoseScreenState extends State<RoseScreen> {
  //* Form key
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  //* Form controller
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  //* Form data
  bool _loadedRose = false;
  List listRose = [];
  List listCoin = [];
  int totalRose = 0;
  int totalCoin = 0;
  int currentPage = 1;
  ScrollController scrollController = ScrollController();

  //* Tab index
  int currentIndex = 0;

  @override
  void initState() {
    _loadFormData();
    _setDefaultDate();
    super.initState();
  }

  _setDefaultDate() {
    fromDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.utc(DateTime.now().year, DateTime.now().month, 1));
    toDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlocUser, BlocUserState>(
      listener: (context, state) {
        setState(() {
          _loadedRose = state is! BlocUserLoading;
        });
        if (state is BlocUserLoadedRose) {
          listCoin = state.dataCoin;
          listRose = state.dataRose;
          totalRose = state.totalRose ?? 0;
          totalCoin = state.totalCoin ?? 0;
        }
      },
      child: RTabBarLayout(
        user: widget.user,
        globalKey: globalKey,
        title: 'GIAO DỊCH',
        showBottomNavBar: true,
        bottomNavIndex: 2,
        overlayLoading: !_loadedRose,
        tabs: const [
          Tab(child: Text('Giao dịch hoa hồng')),
          Tab(child: Text('Giao dịch ví xu')),
        ],
        screens: [
          _buildRoseBody(context),
          _buildCoinBody(context),
        ],
        onTabChange: (index) {
          currentIndex = index;
          _setDefaultDate();
        },
      ),
    );
  }

  Future<void> _onRefreshForm() async {
    setState(() {
      _loadedRose = false;
      currentPage = 1;
      _loadFormData();
    });
  }

  RTabBarViewItem _buildRoseBody(BuildContext context) {
    return RTabBarViewItem(
      onRefresh: _onRefreshForm,
      body: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 25,
              child: RTextField(
                label: 'Từ ngày',
                prefixIcon: FontAwesomeIcons.calendarDays,
                controller: fromDateController,
                type: RTextFieldType.date,
                onDateConfirm: _dateSearchData,
                onDateRemove: _dateSearchData,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 25,
              child: RTextField(
                label: 'Đến ngày',
                prefixIcon: FontAwesomeIcons.calendarDays,
                controller: toDateController,
                type: RTextFieldType.date,
                onDateConfirm: _dateSearchData,
                onDateRemove: _dateSearchData,
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const RText(title: 'Tổng hoa hồng', type: RTextType.title, color: themeColor),
            RText(title: totalRose == 0 ? '0 VNĐ' : '${totalRose.toString()} Triệu', type: RTextType.title, color: themeColor),
          ],
        ),
        const Divider(),
        ...List<Widget>.generate(
          listRose.length,
          (index) => RRoseItem(
            data: listRose[index],
          ),
        ),
      ],
    );
  }

  RTabBarViewItem _buildCoinBody(BuildContext context) {
    return RTabBarViewItem(
      onRefresh: _onRefreshForm,
      body: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 25,
              child: RTextField(
                label: 'Từ ngày',
                prefixIcon: FontAwesomeIcons.calendarDays,
                controller: fromDateController,
                type: RTextFieldType.date,
                onDateConfirm: _dateSearchData,
                onDateRemove: _dateSearchData,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 25,
              child: RTextField(
                label: 'Đến ngày',
                prefixIcon: FontAwesomeIcons.calendarDays,
                controller: toDateController,
                type: RTextFieldType.date,
                onDateConfirm: _dateSearchData,
                onDateRemove: _dateSearchData,
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const RText(title: 'Tổng xu', type: RTextType.title, color: themeColor),
            RIconText(
                icon: FontAwesomeIcons.coins,
                title: NumberFormat().format(double.parse(totalCoin.toString())),
                type: RTextType.subtitle,
                color: Colors.orange),
          ],
        ),
        const Divider(),
        ...List<Widget>.generate(
          listCoin.length,
          (index) => RCoinItem(
            data: listCoin[index],
          ),
        ),
      ],
    );
  }

  void _dateSearchData() {
    setState(() {
      currentPage = 1;
      listRose = [];
      _loadFormData();
    });
  }

  void _loadFormData() {
    BlocProvider.of<BlocUser>(context).add(
      BlocLoadUserRoseEvent(
        userInfo: widget.user,
        dateFrom: fromDateController.text,
        dateTo: toDateController.text,
        page: currentPage,
      ),
    );
  }
}
