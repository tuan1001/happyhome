import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rcore/bloc/customer/bloc_customer.dart';
import 'package:rcore/utils/color/theme.dart';
import 'package:rcore/utils/r-button/text_button.dart';
import 'package:rcore/utils/r-layout/sub_layout.dart';
import 'package:rcore/utils/r-text/icon_text.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/utils/r-text/type.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../models/user.dart';
import '../../utils/r-button/round_button.dart';
import '../../utils/r-button/type.dart';
import '../../utils/r-dialog/dialog.dart';
import '../../utils/r-dialog/notification_dialog.dart';
import '../../utils/r-dialog/yes_no_dialog.dart';
import '../../utils/r-snackbar/snackbar.dart';
import '../../utils/r-textfield/textfield.dart';
import '../../utils/r-textfield/type.dart';

class CustomerDetailScreen extends StatefulWidget {
  final User user;
  final Map<String, dynamic>? loadedData;
  final int customerId;
  const CustomerDetailScreen({
    Key? key,
    required this.user,
    required this.loadedData,
    required this.customerId,
  }) : super(key: key);

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  // bool overlayLoading = false;

  Map<String, dynamic> customerData = {};
  bool loadedCustomer = false;

  @override
  void initState() {
    customerData = widget.loadedData!;
    super.initState();
  }

  //* Form size
  Size formSize = const Size(0, 0);

  @override
  Widget build(BuildContext context) {
    formSize = MediaQuery.of(context).size;
    return BlocListener<BlocCustomer, BlocCustomerState>(
      listener: (context, state) {
        setState(() {
          loadedCustomer = state is! BlocCustomerLoading;
        });

        if (state is BlocCustomerError) {
          showRNotificationDialog(context, 'Th??ng b??o', state.message);
        }

        if (state is BlocCustomerLoadDetailsSuccess) {
          customerData = state.customerData;
        }

        if (state is BlocCustomerUpdateDetailSuccess) {
          showRToast(message: state.message);
          customerData = state.customerData;
          Navigator.of(context, rootNavigator: false).pop();
        }

        if (state is BlocCustomerDeleteSuccess) {
          showRToast(message: state.message);
          Navigator.of(context, rootNavigator: false).pop();
        }
      },
      child: RSubLayout(
        user: widget.user,
        globalKey: globalKey,
        title: 'Chi ti???t kh??ch h??ng',
        enableAction: true,
        bottomNavIndex: 1,
        contenPadding: EdgeInsets.zero,
        body: _buildBody(context, formSize),
      ),
    );
  }

  List<Widget> _buildBody(BuildContext context, Size size) {
    return [
      Container(
        constraints: BoxConstraints(
          minHeight: size.height - 103.7 - size.width * .155,
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              child: const RText(
                title: 'Th??ng tin kh??ch h??ng',
                type: RTextType.title,
                color: Color.fromRGBO(38, 108, 145, 1),
              ),
            ),
            RIconText(
              title: '  ${customerData['data']['hoten'] ?? ''}',
              icon: FontAwesomeIcons.solidCircleUser,
              iconColor: _getCustomerColor(customerData['data']['kich_hoat']!),
            ),
            const Divider(height: 3),
            const SizedBox(height: 5),
            RIconText(title: '  ${customerData['data']['dien_thoai'] ?? ''}', icon: FontAwesomeIcons.phone),
            const Divider(height: 5),
            const Align(
              alignment: Alignment.centerLeft,
              child: RText(title: 'Nhu c???u kh??ch h??ng', type: RTextType.subtitle, color: Colors.black),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RText(
                title: customerData['data']['ghi_chu'] ?? '',
                type: RTextType.text,
              ),
            ),
            if (customerData['data']['kich_hoat'] == 'Ch??? x??c minh') const Divider(),
            if (customerData['data']['kich_hoat'] == 'Ch??? x??c minh')
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RTextButton(
                      text: 'S???a',
                      onPressed: () {
                        TextEditingController nameController = TextEditingController(text: customerData['data']['hoten'] ?? '');
                        TextEditingController phoneController = TextEditingController(text: customerData['data']['dien_thoai'] ?? '');
                        TextEditingController noteController = TextEditingController(text: customerData['data']['ghi_chu'] ?? '');
                        showRDiaLog(context, [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 18),
                              const RText(title: 'S???A KH??CH H??NG', type: RTextType.title, color: themeColor),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: false).pop();
                                },
                                child: const Icon(FontAwesomeIcons.xmark, size: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          RTextField(label: 'H??? v?? t??n ???*???', controller: nameController),
                          RTextField(
                            label: 'S??? ??i???n tho???i ???*???',
                            maxLength: 10,
                            controller: phoneController,
                            type: RTextFieldType.number,
                          ),
                          RTextField(
                            label: 'Th??ng tin nhu c???u',
                            controller: noteController,
                            type: RTextFieldType.multiline,
                          ),
                          RButton(
                              text: 'L??u l???i',
                              onPressed: () {
                                BlocProvider.of<BlocCustomer>(context).add(BlocCustomerUpdateDetailEvent(
                                  userInfo: widget.user,
                                  id: widget.customerId,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  note: noteController.text,
                                ));
                              },
                              radius: 5),
                        ]);
                      },
                      icon: FontAwesomeIcons.penToSquare,
                      color: const Color.fromRGBO(31, 136, 180, 1)),
                  const SizedBox(width: 15),
                  RTextButton(
                      text: 'X??a',
                      onPressed: () {
                        showRYesNoDialog(
                          context,
                          'Th??ng b??o',
                          'B???n c?? ch???c ch???n mu???n x??a kh??ch h??ng kh??ng?',
                          () {
                            BlocProvider.of<BlocCustomer>(context).add(BlocCustomerDeleteEvent(
                              userInfo: widget.user,
                              id: widget.customerId,
                            ));
                          },
                          () {
                            Navigator.pop(context);
                          },
                        );
                      },
                      icon: FontAwesomeIcons.trash,
                      color: Colors.red),
                ],
              ),
            const Divider(),
            const RText(title: 'L???ch s??? tr???ng th??i', type: RTextType.title),
            const SizedBox(height: 10),
            if (customerData.isNotEmpty && customerData['trang_thai'].length == 0) const RText(title: 'Kh??ch h??ng ch??a c?? l???ch s??? tr???ng th??i'),
            if (customerData.isNotEmpty)
              ...List<Widget>.generate(
                customerData['trang_thai'].length,
                (index) => TimelineTile(
                  lineXY: 0.3,
                  isFirst: index == 0,
                  isLast: index == customerData['trang_thai'].length - 1,
                  indicatorStyle: IndicatorStyle(
                    width: 15,
                    color: _getCustomerStateColor(customerData['trang_thai'][index]['trang_thai']),
                    padding: const EdgeInsets.all(1),
                  ),
                  beforeLineStyle: const LineStyle(
                    color: Colors.grey,
                  ),
                  endChild: _RightChild(
                    title: customerData['trang_thai'][index]['created'],
                    message: customerData['trang_thai'][index]['trang_thai'],
                  ),
                ),
              ),
            const Divider(),
            const RText(title: 'L???ch s??? giao d???ch', type: RTextType.title),
            const SizedBox(height: 10),
            if (customerData.isNotEmpty && customerData['giao_dich'].length == 0) const RText(title: 'Kh??ch h??ng ch??a c?? l???ch s??? giao d???ch'),
            if (customerData.isNotEmpty)
              ...List<Widget>.generate(
                customerData['giao_dich'].length,
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RIconText(
                        icon: FontAwesomeIcons.calendarDays,
                        title: ' ${customerData['giao_dich'][index]['ngay_cong_chung']}',
                        type: RTextType.label,
                        color: Colors.green),
                    RIconText(
                      icon: FontAwesomeIcons.house,
                      title: ' ${customerData['giao_dich'][index]['title']}',
                      color: themeColor,
                      width: MediaQuery.of(context).size.width - 89,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RIconText(
                            icon: FontAwesomeIcons.tty, title: ' ${customerData['giao_dich'][index]['type_giao_dich']}', type: RTextType.subtitle),
                        RText(title: '${customerData['giao_dich'][index]['hoa_hong']} Tri???u'),
                      ],
                    ),
                    Divider(color: Colors.grey.shade200)
                  ],
                ),
              ),
          ],
        ),
      ),
    ];
  }

  Color _getCustomerColor(String active) {
    switch (active) {
      case 'Ch??? x??c minh':
        return rButtonBackground(RButtonType.warning);
      case '???? x??c minh':
        return const Color.fromRGBO(0, 120, 170, 1);
      case '???? xem':
        return const Color.fromRGBO(170, 20, 240, 1);
      case 'Giao d???ch':
        return const Color.fromRGBO(76, 175, 80, 1);
      case 'Ti???m n??ng':
        return const Color.fromRGBO(84, 99, 255, 1);
      case 'Faild':
        return const Color.fromRGBO(255, 24, 24, 1);
      default:
        return Colors.grey;
    }
  }

  Color _getCustomerStateColor(String active) {
    switch (active) {
      case 'Ch??? duy???t':
        return rButtonBackground(RButtonType.warning);
      // case '???? x??c minh':
      case 'Kh??ch h??ng c?? nhu c???u':
        return const Color.fromRGBO(0, 120, 170, 1);
      case 'Kh??ch h??ng ???? xem':
        return const Color.fromRGBO(170, 20, 240, 1);
      case 'Kh??ch h??ng giao d???ch':
        return const Color.fromRGBO(76, 175, 80, 1);
      case 'Kh??ch h??ng ti???m n??ng':
        return const Color.fromRGBO(84, 99, 255, 1);
      case 'Faild':
        return const Color.fromRGBO(255, 24, 24, 1);
      default:
        return Colors.grey;
    }
  }
}

class _RightChild extends StatelessWidget {
  final String title;
  final String message;

  const _RightChild({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RIconText(icon: FontAwesomeIcons.calendarDays, title: title, type: RTextType.label, color: Colors.green),
              RText(title: message, type: RTextType.subtitle),
            ],
          ),
        ],
      ),
    );
  }
}
