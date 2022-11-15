// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rcore/bloc/request/bloc_request.dart';

import 'package:rcore/models/request.dart';
import 'package:rcore/utils/r-button/round_button.dart';
import 'package:rcore/utils/r-dialog/notification_dialog.dart';
import 'package:rcore/utils/r-layout/sub_layout.dart';
import 'package:rcore/utils/r-snackbar/snackbar.dart';
import 'package:rcore/utils/r-textfield/textfield.dart';
import 'package:rcore/utils/r-textfield/type.dart';
import 'package:rcore/views/request/detail_request.dart';

import '../../models/user.dart';
import '../../utils/color/theme.dart';
import '../../utils/r-dialog/dialog.dart';
import '../../utils/r-navigator/navigator.dart';
import '../../utils/r-text/title.dart';
import '../../utils/r-text/type.dart';

class RequestScreen extends StatefulWidget {
  // final ReceivedNotification? receivedNotification;
  final User user;
  const RequestScreen({
    Key? key,
    required this.user,
    // this.receivedNotification,
  }) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  //* Form controller
  TextEditingController feedbackContentController = TextEditingController();
  TextEditingController notificationContentController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  //* Load list notification
  bool _isLoadedRequest = true;
  List<Request> listRequests = [];

  //* Page navigation
  int pageIndex = 1;
  int pageMaxSize = 1;

  @override
  void initState() {
    _loadListRequest();
    _setDefaultDate();
    super.initState();
  }

  Size formSize = const Size(0, 0);

  _setDefaultDate() {
    fromDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.utc(DateTime.now().year, DateTime.now().month, 1));
    toDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    formSize = MediaQuery.of(context).size;
    return BlocListener<BlocRequest, BlocRequestState>(
      listener: (context, state) {
        setState(() {
          _isLoadedRequest = state is! BlocRequestLoadingState;
        });

        if (state is BlocRequestError) {
          showRNotificationDialog(context, 'Thông báo', state.message);
        }

        if (state is BlocListRequestsLoadedSuccessState) {
          // AwesomeNotifications().createNotification(
          //   content: NotificationContent(
          //     id: 10,
          //     channelKey: 'basic_channel',
          //     title: 'Thông báo',
          //     body: state.data['message'],
          //   ),
          // );
          listRequests = state.requests;
          pageIndex = state.page;
          pageMaxSize = state.maxPage;
        }

        if (state is BlocRequestAddedState) {
          showRToast(message: state.message);
          Navigator.of(context, rootNavigator: false).pop();
          pageIndex = 1;
          _loadListRequest();
        }
      },
      child: RSubLayout(
        user: widget.user,
        globalKey: globalKey,
        bottomNavIndex: 3,
        extendBody: false,
        onRefresh: _onRefresh,
        overlayLoading: !_isLoadedRequest,
        title: 'Yêu cầu',
        backgroundColor: const Color.fromRGBO(235, 235, 237, 1),
        contenPadding: const EdgeInsets.all(10.0),
        body: _buildBody(context, formSize),
      ),
    );
  }

  Future<void> _onRefresh() async {
    pageIndex = 1;
    _loadListRequest();
  }

  List<Widget> _buildBody(BuildContext context, Size size) {
    return [
      Container(
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          minHeight: size.height - 103.7 - size.width * .155,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5 - 30,
                  child: RTextField(
                    label: 'Nội dung tìm kiếm',
                    controller: _searchController,
                    borderRadius: 5,
                    onTextChange: (value) {
                      if (value.isEmpty) {
                        pageIndex = 1;
                        _loadListRequest();
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
                      pageIndex = 1;
                      _loadListRequest();
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
                      TextEditingController titleController = TextEditingController();
                      TextEditingController requestContentController = TextEditingController();
                      showRDiaLog(
                        context,
                        [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 18),
                              const RText(title: 'THÊM YÊU CẦU', type: RTextType.title, color: themeColor),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: false).pop();
                                },
                                child: const Icon(FontAwesomeIcons.xmark, size: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          RTextField(
                            label: 'Tiêu đề',
                            controller: titleController,
                          ),
                          RTextField(
                            label: 'Nội dung',
                            controller: requestContentController,
                            type: RTextFieldType.multiline,
                          ),
                          RButton(
                            text: 'Lưu lại',
                            onPressed: () {
                              BlocProvider.of<BlocRequest>(context).add(BlocAddRequestEvent(
                                user: widget.user,
                                title: titleController.text,
                                requestContent: requestContentController.text,
                              ));
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
            if (listRequests.isEmpty) const RText(title: 'Hiện chưa có thông báo nào', type: RTextType.title),
            ...List.generate(
              listRequests.length,
              (index) => _buildRequestItem(context, request: listRequests[index]),
            ),
            SizedBox(height: _getBottomSize(formSize, listRequests.length)),
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
                          _loadFormData();
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
                        _loadFormData();
                      },
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      color: (pageIndex < pageMaxSize) ? textColor : Colors.transparent,
                    ),
                  ],
                ),
              )
          ],
        ),
      )
    ];
  }

  Widget _buildRequestItem(BuildContext context, {required Request request}) {
    return InkWell(
      onTap: () async {
        await toScreen(DetailRequestScreen(user: widget.user, id: request.id), context);
        _loadFormData();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: _requestStatusBackgroundColor(request.status),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RText(
                  title: '#Tiket ${request.id}',
                  type: RTextType.subtitle,
                ),
                RText(
                  title: request.status,
                  type: RTextType.subtitle,
                  color: _requestStatusColor(request.status),
                ),
              ],
            ),
            const Divider(height: 10),
            RText(title: request.title, type: RTextType.title, alignment: Alignment.centerLeft, maxLines: 1, textOverflow: TextOverflow.ellipsis),
            const SizedBox(height: 3),
            RText(title: 'Cập nhật: ${request.updateTime}', type: RTextType.label, color: Colors.grey, alignment: Alignment.centerLeft),
          ],
        ),
      ),
    );
  }

  _getBottomSize(Size size, int numOfRequest) {
    double res = size.height - 267.7 - size.width * 0.155 - numOfRequest * 97 - 40;
    return res < 0 ? 0.0 : res;
  }

  _dateSearchData() {
    pageIndex = 1;
    _loadListRequest();
  }

  _loadFormData() {
    BlocProvider.of<BlocRequest>(context).add(BlocLoadListRequestsEvent(
      user: widget.user,
      fromDate: fromDateController.text,
      toDate: toDateController.text,
      page: pageIndex,
      searchContent: _searchController.text,
    ));
  }

  void _loadListRequest() {
    listRequests = [];
    _loadFormData();
  }

  Color _requestStatusColor(String status) {
    switch (status) {
      case 'Quản lý CTV đã trả lời':
        return const Color.fromRGBO(76, 175, 80, 1);
      case 'Chờ QLCTV trả lời':
        return const Color.fromRGBO(255, 195, 0, 1);
      default:
        return Colors.red;
    }
  }

  Color _requestStatusBackgroundColor(String status) {
    switch (status) {
      case 'Quản lý CTV đã trả lời':
        return const Color.fromRGBO(219, 239, 220, 1);
      case 'Chờ QLCTV trả lời':
        return const Color.fromRGBO(255, 237, 178, 1);
      default:
        return Colors.white;
    }
  }
}
