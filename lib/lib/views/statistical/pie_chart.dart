import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rcore/utils/r-button/round_button.dart';
import 'package:rcore/utils/r-button/text_button.dart';
import 'package:rcore/utils/r-text/title_and_text.dart';
import 'package:rcore/utils/r-text/type.dart';

import '../../utils/r-text/title.dart';

/// Icons by svgrepo.com (https://www.svgrepo.com/collection/job-and-professions-3/)
class CustomerStatisticalPieChart extends StatefulWidget {
  final Map<String, dynamic>? statisticalData;
  final String fromDate;
  final String toDate;
  const CustomerStatisticalPieChart({
    Key? key,
    this.statisticalData,
    required this.fromDate,
    required this.toDate,
  }) : super(key: key);

  @override
  State<CustomerStatisticalPieChart> createState() => _CustomerStatisticalPieChartState();
}

class _CustomerStatisticalPieChartState extends State<CustomerStatisticalPieChart> {
  int touchedIndex = 0;
  bool showAvg = true;

  int total = 0;
  int waitCustomer = 0;
  int successCustomer = 0;
  int seenCustomer = 0;
  int potentialCustomer = 0;
  int failCustomer = 0;
  int transitionCustomer = 0;

  @override
  Widget build(BuildContext context) {
    return showAvg == false
        ? Column(
            children: [
              Text(
                widget.fromDate.isEmpty && widget.toDate.isEmpty
                    ? 'Tổng quan kết quả môi giới tháng ${DateTime.now().month}'
                    : 'Tổng quan kết quả môi giới',
                // : 'Tổng quan kết quả môi giới${widget.fromDate}${widget.toDate}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              RTitleAndText(title: 'Khách hàng chờ xác minh', text: widget.statisticalData?['kh_cho'] ?? '0', underline: true),
              RTitleAndText(title: 'Khách hàng đã xác minh', text: widget.statisticalData?['kh_da_xac_minh'] ?? '0', underline: true),
              RTitleAndText(title: 'Khách hàng đã xem', text: widget.statisticalData?['kh_da_xem'] ?? '0', underline: true),
              RTitleAndText(title: 'Khách hàng giao dịch', text: widget.statisticalData?['kh_giao_dich'] ?? '0', underline: true),
              RTitleAndText(title: 'Khách hàng không được duyệt', text: widget.statisticalData?['kh_faild'] ?? '0', underline: true),
              RTitleAndText(title: 'Tổng số khách hàng', text: widget.statisticalData?['tong'] ?? '0', underline: true),
              RButton(
                text: 'Xem tổng quan',
                onPressed: () {
                  setState(() {
                    showAvg = true;
                  });
                },
                radius: 5,
              ),
            ],
          )
        : Column(
            children: [
              AspectRatio(
                aspectRatio: 1.15,
                child: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 1,
                      centerSpaceRadius: 0,
                      sections: _showingSections()),
                ),
              ),
              if (int.parse(widget.statisticalData?['tong'] ?? '1') != 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (int.parse(widget.statisticalData?['tong'] ?? '0') != 0) const RText(title: 'Chú thích:', type: RTextType.title),
                    RTextButton(
                        text: 'Xem chi tiết',
                        onPressed: () {
                          setState(() {
                            showAvg = false;
                          });
                        }),
                  ],
                ),
              _getDataCustomerSatistic(title: 'KH chờ xác minh:', titleColor: const Color.fromRGBO(33, 150, 243, 1), customerType: waitCustomer),
              _getDataCustomerSatistic(title: 'KH đã xác minh:', titleColor: const Color.fromRGBO(255, 209, 73, 1), customerType: successCustomer),
              _getDataCustomerSatistic(title: 'KH đã xem:', titleColor: const Color.fromRGBO(101, 186, 105, 1), customerType: seenCustomer),
              _getDataCustomerSatistic(title: 'KH tiềm năng:', titleColor: const Color.fromRGBO(147, 105, 211, 1), customerType: potentialCustomer),
              _getDataCustomerSatistic(title: 'KH giao dịch:', titleColor: const Color.fromRGBO(243, 120, 68, 1), customerType: transitionCustomer),
              _getDataCustomerSatistic(title: 'KH không được duyệt:', titleColor: const Color.fromRGBO(62, 132, 134, 1), customerType: failCustomer),
            ],
          );
  }

  Widget _getDataCustomerSatistic({required String title, required Color titleColor, required int customerType}) {
    return (int.parse(widget.statisticalData?['tong'] ?? '0') == 0)
        ? Container()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 200, child: RText(title: title, color: titleColor, type: RTextType.subtitle)),
              RText(title: _getToolTipData(customerType, total), type: RTextType.subtitle),
            ],
          );
  }

  PieChartSectionData getSectionData(int currentIndex, int currentValue, int maxValue, Color color, {bool centerTitle = false}) {
    final isTouched = currentIndex == touchedIndex;
    final fontSize = isTouched ? 18.0 : 14.0;
    final radius = isTouched ? 110.0 : 100.0;
    final widgetSize = isTouched ? 55.0 : 40.0;

    return PieChartSectionData(
      borderSide: BorderSide(width: 1, color: color.withOpacity(0.9)),
      color: color,
      value: currentValue == 0 ? 1 : currentValue.toDouble(),
      title: currentValue == 0 ? '0%' : '${(currentValue * 100 / maxValue).toStringAsFixed(1)}%',
      radius: radius,
      titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      titlePositionPercentageOffset: centerTitle ? 0 : 0.5,
      badgeWidget: _Badge(
        size: widgetSize,
        borderColor: color,
        tooltip: _getToolTipData(currentValue, maxValue),
      ),
      badgePositionPercentageOffset: centerTitle ? 0 : 0.5,
    );
  }

  _getToolTipData(int currentValue, int maxValue) {
    int afterDot = currentValue == 0 ? 0 : 1;
    return '$currentValue - ${(currentValue * 100 / maxValue).toStringAsFixed(afterDot)}%';
  }

  List<PieChartSectionData> _showingSections() {
    List<PieChartSectionData> listSections = [];
    List<Map<String, dynamic>> listSectionProperties = [];

    total = int.parse(widget.statisticalData?['tong'] ?? '1');
    waitCustomer = int.parse(widget.statisticalData?['kh_cho'] ?? '0');
    successCustomer = int.parse(widget.statisticalData?['kh_da_xac_minh'] ?? '0');
    seenCustomer = int.parse(widget.statisticalData?['kh_da_xem'] ?? '0');
    potentialCustomer = int.parse(widget.statisticalData?['kh_tiem_nang'] ?? '0');
    transitionCustomer = int.parse(widget.statisticalData?['kh_giao_dich'] ?? '0');
    failCustomer = int.parse(widget.statisticalData?['kh_faild'] ?? '0');

    int count = 0;

    if (waitCustomer > 0) {
      count++;
      listSectionProperties.add({'value': waitCustomer, 'color': const Color.fromRGBO(33, 150, 243, 1)});
    }

    if (successCustomer > 0) {
      count++;
      listSectionProperties.add({'value': successCustomer, 'color': const Color.fromRGBO(255, 209, 73, 1)});
    }

    if (seenCustomer > 0) {
      count++;
      listSectionProperties.add({'value': seenCustomer, 'color': const Color.fromRGBO(76, 175, 80, 1)});
    }

    if (potentialCustomer > 0) {
      count++;
      listSectionProperties.add({'value': potentialCustomer, 'color': const Color.fromRGBO(147, 105, 211, 1)});
    }

    if (transitionCustomer > 0) {
      count++;
      listSectionProperties.add({'value': transitionCustomer, 'color': const Color.fromRGBO(243, 120, 68, 1)});
    }

    if (failCustomer > 0) {
      count++;
      listSectionProperties.add({'value': failCustomer, 'color': const Color.fromRGBO(62, 132, 134, 1)});
    }

    if (count == 0) {
      listSections.add(getSectionData(1, 0, 1, Colors.grey.shade400, centerTitle: true));
    } else if (count == 1) {
      listSections.add(getSectionData(0, listSectionProperties[0]['value'], total, listSectionProperties[0]['color'], centerTitle: true));
    } else {
      for (int i = 0; i < count; i++) {
        listSections.add(getSectionData(i, listSectionProperties[i]['value'], total, listSectionProperties[i]['color']));
      }
    }

    return listSections;
  }
}

class _Badge extends StatelessWidget {
  final double size;
  final Color borderColor;
  final String? tooltip;

  const _Badge({
    Key? key,
    required this.size,
    required this.borderColor,
    this.tooltip = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 500),
      child: AnimatedContainer(
        duration: PieChart.defaultDuration,
        width: size,
        height: size,
        // decoration: BoxDecoration(
        //   color: Colors.transparent,
        //   shape: BoxShape.circle,
        //   border: Border.all(
        //     color: borderColor,
        //     width: 2,
        //   ),
        //   boxShadow: <BoxShadow>[
        //     BoxShadow(
        //       color: Colors.black.withOpacity(.5),
        //       offset: const Offset(3, 3),
        //       blurRadius: 3,
        //     ),
        //   ],
        // ),
        padding: EdgeInsets.all(size * .15),
      ),
    );
  }
}
