// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rcore/models/user.dart';
import 'package:rcore/utils/r-layout/sub_layout.dart';

import '../../bloc/customer/bloc_customer.dart';
import '../../models/customer.dart';
import '../../utils/color/theme.dart';
import '../../utils/r-button/round_button.dart';
import '../../utils/r-button/type.dart';
import '../../utils/r-dialog/dialog.dart';
import '../../utils/r-dialog/notification_dialog.dart';
import '../../utils/r-dialog/yes_no_dialog.dart';
import '../../utils/r-navigator/navigator.dart';
import '../../utils/r-snackbar/snackbar.dart';
import '../../utils/r-text/icon_text.dart';
import '../../utils/r-text/title.dart';
import '../../utils/r-text/type.dart';
import '../../utils/r-textfield/textfield.dart';
import '../../utils/r-textfield/type.dart';
import 'customer_detail_screen.dart';

class CustomerScreen extends StatefulWidget {
  final Map<String, dynamic>? userInfo;
  final User user;
  const CustomerScreen({
    super.key,
    this.userInfo,
    required this.user,
  });

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  //* global key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? statisticalData;

  //* Form list data
  List<Customer> listKhachhang = [];
  Map<String, dynamic> statistic = {};
  String active = '';

  //* Form controller
  final TextEditingController _searchController = TextEditingController();

  //* Search visible
  bool isSearchBarVisible = false;

  //* Page controller
  bool loadedKhachHang = false;
  int pageIndex = 1;
  int pageMaxSize = 1;

  //* Form size
  Size size = Size.zero;

  @override
  void initState() {
    _loadRemainingFormData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return BlocListener<BlocCustomer, BlocCustomerState>(
      listener: (context, state) async {
        setState(() {
          loadedKhachHang = state is! BlocCustomerLoading;
        });

        if (state is BlocCustomerError) {
          showRNotificationDialog(context, 'Thông báo', state.message);
        }

        if (state is BlocCustomerLoadListSuccess) {
          listKhachhang = state.listCustomer;
          statistic = state.statistic;
          pageIndex = state.page;
          pageMaxSize = state.maxPage;
        }

        if (state is BlocCustomerCreateSuccess) {
          showRToast(message: state.message);
          Navigator.of(context, rootNavigator: false).pop();
          pageIndex = 1;
          _loadRemainingFormData();
        }

        if (state is BlocCustomerLoadDetailsSuccess) {
          await toScreen(CustomerDetailScreen(loadedData: state.customerData, customerId: state.id, user: widget.user), context);
          _loadRemainingFormData();
        }

        if (state is BlocCustomerUpdateSuccess) {
          showRToast(message: state.message);
          Navigator.of(context, rootNavigator: false).pop();
          _loadFormData();
        }

        if (state is BlocCustomerDeleteSuccess) {
          Navigator.of(context, rootNavigator: false).pop();
          showRToast(message: state.message);
          _loadFormData();
        }
      },
      child: RSubLayout(
        globalKey: _scaffoldKey,
        user: widget.user,
        title: 'Khách hàng',
        showBottomNavBar: true,
        // backgroundColor: const Color.fromRGBO(235, 235, 237, 1),
        contenPadding: EdgeInsets.zero,
        extendBody: false,
        onRefresh: _onRefreshForm,
        bottomNavIndex: 1,
        overlayLoading: loadedKhachHang == false,
        body: _getBody(context),
      ),
    );
  }

  Future<void> _onRefreshForm() async {
    active = '';
    pageIndex = 1;
    _loadRemainingFormData();
  }

  List<Widget> _getBody(BuildContext context) {
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
          children: [
            RIconText(
              mainAxisAlignment: MainAxisAlignment.center,
              icon: FontAwesomeIcons.userGroup,
              title: '  ${statistic['tong'] ?? 0} KHÁCH HÀNG',
              type: RTextType.header1,
              color: const Color.fromRGBO(28, 101, 140, 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _getCustomerStatistic(
                    backgroundColor: const Color.fromRGBO(255, 195, 0, 1), count: statistic['kh_cho'] ?? '0', title: 'Chờ xác minh'),
                _getCustomerStatistic(
                    backgroundColor: const Color.fromRGBO(0, 120, 170, 1), count: statistic['kh_da_xac_minh'] ?? '0', title: 'Đã xác minh'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _getCustomerStatistic(backgroundColor: const Color.fromRGBO(170, 20, 240, 1), count: statistic['kh_da_xem'] ?? '0', title: 'Đã xem'),
                _getCustomerStatistic(
                    backgroundColor: const Color.fromRGBO(84, 99, 255, 1), count: statistic['kh_tiem_nang'] ?? '0', title: 'Tiềm năng'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _getCustomerStatistic(
                    backgroundColor: const Color.fromRGBO(76, 175, 80, 1), count: statistic['kh_giao_dich'] ?? '0', title: 'Giao dịch'),
                _getCustomerStatistic(
                    backgroundColor: const Color.fromRGBO(255, 24, 24, 1), count: statistic['kh_faild'] ?? '0', title: 'Không duyệt'),
              ],
            ),
            const Divider(),
            RText(
                title: active.isEmpty ? 'DANH SÁCH KHÁCH HÀNG' : 'Khách hàng ${active == 'faild' ? 'Không duyệt' : active}'.toUpperCase(),
                type: RTextType.header2,
                color: Colors.black),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5 - 30,
                  child: RTextField(
                    label: 'Tìm kiếm khách hàng',
                    controller: _searchController,
                    borderRadius: 5,
                    onTextChange: (value) {
                      if (value.isEmpty) {
                        pageIndex = 1;
                        active = '';
                        _loadRemainingFormData();
                      }
                    },
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5 - 80,
                  child: RButton(
                    icon: Icons.search_rounded,
                    text: 'Tìm kiếm',
                    onPressed: () {
                      if (_searchController.text.isEmpty) {
                        showRToast(message: 'Vui lòng nhập thông tin tìm kiếm', type: ToastType.normal);
                        return;
                      }
                      pageIndex = 1;
                      pageMaxSize = 1;
                      active = '';
                      _loadRemainingFormData();
                    },
                    backgroundColor: const Color.fromRGBO(0, 120, 170, 1),
                    radius: 10,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 45,
                  child: RButton(
                    backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
                    radius: 100,
                    icon: Icons.add,
                    onPressed: () {
                      TextEditingController nameController = TextEditingController();
                      TextEditingController phoneController = TextEditingController();
                      TextEditingController noteController = TextEditingController();
                      showRDiaLog(
                        context,
                        [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 18),
                              const RText(title: 'THÊM KHÁCH HÀNG', type: RTextType.title, color: themeColor),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: false).pop();
                                },
                                child: const Icon(FontAwesomeIcons.xmark, size: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          RTextField(label: 'Họ và tên ⁽*⁾', controller: nameController),
                          RTextField(
                            label: 'Số điện thoại ⁽*⁾',
                            controller: phoneController,
                            type: RTextFieldType.number,
                            maxLength: 10,
                          ),
                          RTextField(
                            label: 'Thông tin nhu cầu',
                            controller: noteController,
                            type: RTextFieldType.multiline,
                          ),
                          RButton(
                            text: 'Thêm khách hàng',
                            onPressed: () {
                              BlocProvider.of<BlocCustomer>(context).add(
                                BlocCustomerCreateEvent(
                                  userInfo: widget.user,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  note: noteController.text,
                                ),
                              );
                            },
                            radius: 5,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            const Divider(),
            if (listKhachhang.isNotEmpty)
              ...List<Widget>.generate(
                listKhachhang.length,
                (index) => _buildCustomerItem(
                  context,
                  customerInfo: listKhachhang[index],
                ),
              ),
            if (listKhachhang.isNotEmpty) SizedBox(height: _getBottomSize(listKhachhang.length, size)),
            if (pageMaxSize > 1)
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (pageIndex > 1) {
                          pageIndex--;
                          _loadRemainingFormData();
                        }
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: (pageIndex > 1) ? textColor : Colors.transparent,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: buttonPrimaryColorActive,
                              style: BorderStyle.solid,
                              width: 1.0,
                            ),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(30))),
                        child: Text('$pageIndex'),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (pageIndex < pageMaxSize) pageIndex++;
                        _loadRemainingFormData();
                      },
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      color: (pageIndex < pageMaxSize) ? textColor : Colors.transparent,
                    ),
                  ],
                ),
              ),
          ],
        ),
      )
    ];
  }

  _getBottomSize(int numberOfCustomer, Size screenSize) {
    double size = screenSize.height - (530.7 + screenSize.width * 0.155 + numberOfCustomer * 38.5);
    return size > 0 ? size : 0.0;
  }

  Widget _getCustomerStatistic({required Color backgroundColor, required String count, required String title}) {
    return InkWell(
      onTap: () {
        active = title == 'Không duyệt' ? 'faild' : title;
        pageIndex = 1;
        _loadRemainingFormData();
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 25,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(
              FontAwesomeIcons.userGroup,
              color: Colors.white,
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RText(title: count, type: RTextType.title, color: Colors.white),
                RText(title: title, type: RTextType.text, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerItem(
    BuildContext context, {
    required Customer customerInfo,
  }) {
    return Slidable(
      key: ObjectKey(customerInfo),
      startActionPane: _updateCustomerFunction(customerInfo, context),
      endActionPane: _deleteCustomerFunction(context, customerInfo),
      child: InkWell(
        onTap: () {
          BlocProvider.of<BlocCustomer>(context).add(BlocCustomerDetailEvent(
            userInfo: widget.user,
            id: customerInfo.id ?? 0,
          ));
        },
        child: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade200,
                width: 0.5,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RIconText(
                    maxLines: 1,
                    width: MediaQuery.of(context).size.width - 180,
                    title: ' ${customerInfo.name ?? ''}',
                    icon: FontAwesomeIcons.solidCircleUser,
                    color: Colors.black,
                    iconColor: _getCustomerLabel(customerInfo.active ?? ''),
                  ),
                  RIconText(title: ' ${customerInfo.phone ?? ''}', icon: FontAwesomeIcons.phone),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ActionPane _deleteCustomerFunction(BuildContext context, Customer customerInfo) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
            label: 'Xóa',
            backgroundColor: Colors.red,
            onPressed: (_) {
              if (customerInfo.active != 'Chờ xác minh') {
                showRToast(message: 'Chỉ có thể xóa khách hàng chưa xác minh', gravity: ToastGravity.SNACKBAR, type: ToastType.warning);
                return;
              }
              showRYesNoDialog(
                context,
                'Thông báo',
                'Bạn có chắc chắn muốn xóa khách hàng không?',
                () {
                  BlocProvider.of<BlocCustomer>(context).add(BlocCustomerDeleteEvent(
                    userInfo: widget.user,
                    id: customerInfo.id ?? 0,
                  ));
                },
                () {
                  Navigator.pop(context);
                },
              );
            })
      ],
    );
  }

  ActionPane _updateCustomerFunction(Customer customerInfo, BuildContext context) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          label: 'Sửa',
          backgroundColor: Colors.green,
          onPressed: (_) {
            if (customerInfo.active != 'Chờ xác minh') {
              showRToast(message: 'Chỉ có thể sửa khách hàng chưa xác minh', gravity: ToastGravity.SNACKBAR, type: ToastType.warning);
              return;
            }

            TextEditingController nameController = TextEditingController(text: customerInfo.name ?? '');
            TextEditingController phoneController = TextEditingController(text: customerInfo.phone ?? '');
            TextEditingController noteController = TextEditingController(text: customerInfo.note ?? '');
            showRDiaLog(context, [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 18),
                  const RText(title: 'SỬA KHÁCH HÀNG', type: RTextType.title, color: themeColor),
                  InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: false).pop();
                    },
                    child: const Icon(FontAwesomeIcons.xmark, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              RTextField(label: 'Họ và tên ⁽*⁾', controller: nameController),
              RTextField(
                label: 'Số điện thoại ⁽*⁾',
                maxLength: 10,
                controller: phoneController,
                type: RTextFieldType.number,
              ),
              RTextField(
                label: 'Thông tin nhu cầu',
                controller: noteController,
                type: RTextFieldType.multiline,
              ),
              RButton(
                  text: 'Lưu lại',
                  onPressed: () {
                    BlocProvider.of<BlocCustomer>(context).add(BlocCustomerUpdateEvent(
                      userInfo: widget.user,
                      id: customerInfo.id ?? 0,
                      name: nameController.text,
                      phone: phoneController.text,
                      note: noteController.text,
                    ));
                  },
                  radius: 5),
            ]);
          },
        )
      ],
    );
  }

  _loadFormData() {
    BlocProvider.of<BlocCustomer>(context).add(BlocCustomerLoadListEvent(
      userInfo: widget.user,
      page: pageIndex,
      keySearch: _searchController.text,
      active: active,
    ));
  }

  _loadRemainingFormData() {
    listKhachhang = [];
    _loadFormData();
  }

  Color _getCustomerLabel(String active) {
    switch (active) {
      case 'Chờ xác minh':
        return rButtonBackground(RButtonType.warning);
      case 'Đã xác minh':
        return const Color.fromRGBO(0, 120, 170, 1);
      case 'Đã xem':
        return const Color.fromRGBO(170, 20, 240, 1);
      case 'Giao dịch':
        return const Color.fromRGBO(76, 175, 80, 1);
      case 'Tiềm năng':
        return const Color.fromRGBO(84, 99, 255, 1);
      case 'Faild':
        return const Color.fromRGBO(255, 24, 24, 1);
      default:
        return Colors.grey;
    }
  }
}
