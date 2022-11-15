import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rcore/models/customer.dart';
import 'package:rcore/utils/color/theme.dart';
import 'package:rcore/utils/r-layout/sub_layout.dart';
import 'package:rcore/utils/r-tab_control/tab_content.dart';
import 'package:rcore/utils/r-tab_control/tab_control.dart';
import 'package:rcore/utils/r-tab_control/tab_header.dart';
import 'package:rcore/utils/r-text/icon_text.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/utils/r-text/title_and_text.dart';
import 'package:rcore/utils/r-text/type.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customerInfo;
  final Map<String, dynamic>? loadedData;
  const CustomerDetailScreen({
    Key? key,
    required this.customerInfo,
    required this.loadedData,
  }) : super(key: key);

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  // bool overlayLoading = false;

  bool loadedData = true;
  Map<String, dynamic> jsonData = {};

  @override
  void initState() {
    jsonData = widget.loadedData!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RSubLayout(
      globalKey: globalKey,
      title: 'Chi tiết khách hàng',
      showBottomNavBar: false,
      body: _buildBody(context),
    );
  }

  List<Widget> _buildBody(BuildContext context) {
    return [
      RTabControl(headers: const [
        RTabHeader(text: 'Thông tin'),
        RTabHeader(text: 'Trạng thái'),
        RTabHeader(text: 'Giao dịch'),
      ], contents: [
        RTabContent(body: [
          const RText(title: 'Thông tin khách hàng', type: RTextType.title),
          RTitleAndText(
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
            contentWidth: MediaQuery.of(context).size.width - 125,
            text: widget.customerInfo.name ?? '',
            title: 'Họ tên',
            underline: true,
          ),
          RTitleAndText(text: widget.customerInfo.phone ?? '', title: 'Số điện thoại', underline: true),
          const Align(
            alignment: Alignment.centerLeft,
            child: RText(title: 'Nhu cầu', type: RTextType.subtitle, color: themeColor),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: RText(
              title: widget.customerInfo.note ?? '',
              type: RTextType.text,
            ),
          )
        ]),
        RTabContent(body: <Widget>[
          if (jsonData.isNotEmpty && jsonData['trang_thai'].length > 0)
            const RText(title: 'Lịch sử trạng thái', type: RTextType.title)
          else
            const RText(title: 'Khách hàng chưa có lịch sử trạng thái'),
          ...(jsonData.isEmpty
              ? []
              : List<Widget>.generate(
                  jsonData['trang_thai'].length,
                  (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RIconText(
                              icon: FontAwesomeIcons.calendarDays,
                              title: jsonData['trang_thai'][index]['created'],
                              type: RTextType.label,
                              color: Colors.green),
                          RText(title: jsonData['trang_thai'][index]['trang_thai'], type: RTextType.subtitle),
                          // RIconText(icon: FontAwesomeIcons.user, title: jsonData!['trang_thai'][index]['hoten'], color: themeColor),
                          Divider(color: Colors.grey.shade200)
                        ],
                      )))
        ]),
        RTabContent(
            body: <Widget>[
                  if (jsonData.isNotEmpty && jsonData['giao_dich'].length > 0)
                    const RText(title: 'Lịch sử giao dịch', type: RTextType.title)
                  else
                    const RText(title: 'Khách hàng chưa có giao dịch nào'),
                ] +
                (jsonData.isEmpty
                    ? []
                    : List<Widget>.generate(
                        jsonData['giao_dich'].length,
                        (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RIconText(
                                    icon: FontAwesomeIcons.calendarDays,
                                    title: ' ${jsonData['giao_dich'][index]['ngay_cong_chung']}',
                                    type: RTextType.label,
                                    color: Colors.green),
                                RIconText(
                                  icon: FontAwesomeIcons.house,
                                  title: ' ${jsonData['giao_dich'][index]['title']}',
                                  color: themeColor,
                                  width: MediaQuery.of(context).size.width - 89,
                                ),
                                RIconText(
                                    icon: FontAwesomeIcons.tty,
                                    title: ' ${jsonData['giao_dich'][index]['type_giao_dich']}',
                                    type: RTextType.subtitle),
                                Divider(color: Colors.grey.shade200)
                              ],
                            )))),
      ])
    ];
  }
}
