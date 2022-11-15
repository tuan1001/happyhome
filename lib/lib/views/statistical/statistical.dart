import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rcore/bloc/user/bloc_user.dart';
import 'package:rcore/models/user.dart';
import 'package:rcore/utils/r-layout/sub_layout.dart';
import 'package:rcore/views/statistical/pie_chart.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../utils/r-text/title_and_text.dart';
import '../../utils/r-textfield/textfield.dart';
import '../../utils/r-textfield/type.dart';

class Statistical extends StatefulWidget {
  final Map<String, dynamic>? userInfo;
  final User user;
  const Statistical({
    super.key,
    this.userInfo,
    required this.user,
  });

  @override
  State<Statistical> createState() => _StatisticalState();
}

class _StatisticalState extends State<Statistical> {
  //* global key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? statisticalData;

  bool _loadedStatisticalData = false;

  //* Form controller
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  @override
  void initState() {
    _getStatistical();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlocUser, BlocUserState>(
      listener: (context, state) {
        setState(() {
          _loadedStatisticalData = state is! BlocUserLoading;
        });
        if (state is BlocUserStatisticalLoaded) {
          statisticalData = state.data;
        }
      },
      child: RSubLayout(
        globalKey: _scaffoldKey,
        user: widget.user,
        title: 'Thống kê',
        showBottomNavBar: true,
        // backgroundColor: const Color.fromRGBO(235, 235, 237, 1),
        onRefresh: _onRefreshForm,
        bottomNavIndex: 2,
        overlayLoading: _loadedStatisticalData == false,
        body: _getBody,
      ),
    );
  }

  Future<void> _onRefreshForm() async {
    _getStatistical();
  }

  List<Widget> get _getBody {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 25,
            child: RTextField(
              label: 'Từ tháng',
              prefixIcon: FontAwesomeIcons.calendarDays,
              controller: fromDateController,
              type: RTextFieldType.date,
              customDateFormat: 'MM/yyyy',
              datePickerType: DateRangePickerView.year,
              onDateConfirm: _getStatistical,
              onDateRemove: _getStatistical,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 25,
            child: RTextField(
              label: 'Đến tháng',
              prefixIcon: FontAwesomeIcons.calendarDays,
              controller: toDateController,
              type: RTextFieldType.date,
              datePickerType: DateRangePickerView.year,
              customDateFormat: 'MM/yyyy',
              onDateConfirm: _getStatistical,
              onDateRemove: _getStatistical,
            ),
          ),
        ],
      ),
      CustomerStatisticalPieChart(
        statisticalData: statisticalData,
        fromDate: fromDateController.text.isEmpty ? fromDateController.text : ' từ ${fromDateController.text}',
        toDate: toDateController.text.isEmpty ? toDateController.text : ' đến ${toDateController.text}',
      ),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            fromDateController.text.isEmpty && toDateController.text.isEmpty
                ? Text('Thống kê thu nhập tháng ${DateTime.now().month}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
                : const Text('Thống kê thu nhập', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            RTitleAndText(title: 'Hoa hồng trong tháng', text: statisticalData?['tong_xu'] ?? '0', underline: true),
            RTitleAndText(title: 'Tổng hoa hồng nhận được', text: statisticalData?['vi_dien_tu'] ?? '0', underline: true),
            RTitleAndText(title: 'Hoa hồng đã rút', text: statisticalData?['rut_tien'] ?? '0', underline: true),
            RTitleAndText(title: 'Số dư còn lại', text: statisticalData?['vi_dien_tu'] ?? '0', underline: true),
          ],
        ),
      ),
      const SizedBox(height: 50),
    ];
  }

  void _getStatistical() {
    BlocProvider.of<BlocUser>(context).add(BlocLoadUserStatisticalEvent(
      user: widget.user,
      fromDate: fromDateController.text,
      toDate: toDateController.text,
    ));
  }
}
