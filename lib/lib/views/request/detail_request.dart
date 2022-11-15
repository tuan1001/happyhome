import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rcore/bloc/request/bloc_request.dart';
import 'package:rcore/utils/r-button/text_button.dart';
import 'package:rcore/utils/r-dialog/yes_no_dialog.dart';
import 'package:rcore/utils/r-layout/sub_layout.dart';
import 'package:rcore/utils/r-snackbar/snackbar.dart';
import 'package:rcore/utils/r-text/icon_text.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/utils/r-text/type.dart';

import '../../models/user.dart';
import '../../utils/color/theme.dart';
import '../../utils/r-button/round_button.dart';
import '../../utils/r-dialog/dialog.dart';
import '../../utils/r-dialog/notification_dialog.dart';
import '../../utils/r-textfield/textfield.dart';
import '../../utils/r-textfield/type.dart';

class DetailRequestScreen extends StatefulWidget {
  final User user;
  final int id;
  const DetailRequestScreen({super.key, required this.user, required this.id});

  @override
  State<DetailRequestScreen> createState() => _DetailRequestScreenState();
}

class _DetailRequestScreenState extends State<DetailRequestScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  //* Load form data
  bool _isLoadedRequest = false;
  Map<String, dynamic> requestInfo = {};

  @override
  void initState() {
    _loadFormData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlocRequest, BlocRequestState>(
      listener: (context, state) {
        setState(() {
          _isLoadedRequest = state is! BlocRequestLoadingState;
        });

        if (state is BlocRequestError) {
          showRNotificationDialog(context, 'Thông báo', state.message);
        }

        if (state is BlocLoadRequestDetailState) {
          requestInfo = state.request;
        }

        if (state is BlocRequestUpdatedState) {
          Navigator.of(context, rootNavigator: false).pop();
          requestInfo = state.request;
          showRToast(message: state.message);
        }

        if (state is BlocRequestDeletedState) {
          showRToast(message: state.message);
          Navigator.of(context, rootNavigator: false).pop();
          Navigator.of(context).pop();
        }

        if (state is BlocRequestClosedState) {
          showRToast(message: state.message);
          Navigator.of(context, rootNavigator: false).pop();
          Navigator.of(context).pop();
        }

        if (state is BlocRequestReplyAdminState) {
          Navigator.of(context, rootNavigator: false).pop();
          showRToast(message: state.message);
          requestInfo = state.request;
        }
      },
      child: RSubLayout(
        globalKey: globalKey,
        user: widget.user,
        enableAction: true,
        bottomNavIndex: 3,
        overlayLoading: !_isLoadedRequest,
        onRefresh: () async {
          _loadFormData();
        },
        title: 'Yêu cầu',
        backgroundColor: const Color.fromRGBO(235, 235, 237, 1),
        contenPadding: const EdgeInsets.all(10.0),
        body: _buildBody(context),
      ),
    );
  }

  List<Widget> _buildBody(BuildContext context) {
    return [
      Container(
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 103.7 - MediaQuery.of(context).size.width * 0.155,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RText(
              title: 'Thông tin yêu cầu #${requestInfo.isEmpty ? '' : requestInfo['chi_tiet']['id']}',
              type: RTextType.title,
              color: const Color.fromRGBO(31, 103, 141, 1),
              alignment: Alignment.center,
            ),
            RText(title: requestInfo.isEmpty ? '' : requestInfo['chi_tiet']['title'] ?? '', type: RTextType.title),
            RText(
                title: 'Ngày yêu cầu: ${requestInfo.isEmpty ? '' : requestInfo['chi_tiet']['created'] ?? ''}',
                type: RTextType.label,
                color: Colors.grey),
            RText(title: '${requestInfo.isEmpty ? '' : requestInfo['chi_tiet']['noi_dung'] ?? ''}', type: RTextType.text, fontSize: 15),
            const SizedBox(height: 15),
            if (requestInfo.isNotEmpty)
              ...List.generate(
                requestInfo['lich_su'].length,
                (index) => _buildNotificationItem(context, requestInfo['lich_su'][index], index),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RTextButton(
                  icon: FontAwesomeIcons.circleXmark,
                  text: 'Đóng lại',
                  onPressed: () {
                    showRYesNoDialog(
                      context,
                      'Thông báo',
                      'Bạn có chắc chắn muốn đóng yêu cầu này không?',
                      () {
                        BlocProvider.of<BlocRequest>(context).add(BlocCloseRequestEvent(
                          user: widget.user,
                          id: widget.id,
                        ));
                      },
                      () {
                        Navigator.pop(context);
                      },
                    );
                  },
                  color: Colors.black,
                  type: RTextType.title,
                ),
                RTextButton(
                  icon: FontAwesomeIcons.penToSquare,
                  text: 'Sửa',
                  onPressed: () {
                    TextEditingController titleController = TextEditingController(text: requestInfo['chi_tiet']['title'] ?? '');
                    TextEditingController noteController = TextEditingController(text: requestInfo['chi_tiet']['noi_dung'] ?? '');
                    showRDiaLog(
                      context,
                      [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 18),
                            const RText(title: 'SỬA YÊU CẦU', type: RTextType.title, color: themeColor),
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
                          controller: noteController,
                          type: RTextFieldType.multiline,
                        ),
                        RButton(
                          text: 'Cập nhật',
                          onPressed: () {
                            BlocProvider.of<BlocRequest>(context).add(BlocUpdateRequestEvent(
                              user: widget.user,
                              id: requestInfo['chi_tiet']['id'],
                              title: titleController.text,
                              requestContent: noteController.text,
                            ));
                          },
                          radius: 5,
                        ),
                      ],
                    );
                  },
                  color: const Color.fromRGBO(0, 120, 170, 1),
                  type: RTextType.title,
                ),
                RTextButton(
                  icon: FontAwesomeIcons.trashCan,
                  text: 'Xóa',
                  onPressed: () {
                    showRYesNoDialog(
                      context,
                      'Thông báo',
                      'Bạn có chắc chắn muốn xóa yêu cầu này không?',
                      () {
                        BlocProvider.of<BlocRequest>(context).add(BlocDeleteRequestEvent(
                          user: widget.user,
                          id: widget.id,
                        ));
                      },
                      () {
                        Navigator.pop(context);
                      },
                    );
                  },
                  color: Colors.red,
                  type: RTextType.title,
                ),
              ],
            ),
          ],
        ),
      )
    ];
  }

  Container _buildNotificationItem(BuildContext context, Map<String, dynamic> history, int index) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _requestStatusBackgroundColor(history['trang_thai'] ?? ''),
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
              RIconText(title: history['created'] ?? '', icon: FontAwesomeIcons.calendarDays, type: RTextType.label),
              RText(
                title: history['trang_thai'] ?? '',
                type: RTextType.text,
                fontWeight: FontWeight.bold,
                color: _requestStatusColor(history['trang_thai'] ?? ''),
              ),
            ],
          ),
          const Divider(height: 10),
          RText(title: history['noi_dung'], type: RTextType.subtitle, alignment: Alignment.centerLeft),
          const SizedBox(height: 3),
          if (history['trang_thai'] != null && index == 0)
            RTextButton(
              icon: FontAwesomeIcons.arrowRotateRight,
              text: 'Trả lời',
              color: _requestStatusColor(history['trang_thai'] ?? ''),
              onPressed: () {
                TextEditingController replyContentController = TextEditingController();
                showRDiaLog(
                  context,
                  [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 18),
                        const RText(title: 'TRẢ LỜI', type: RTextType.title, color: themeColor),
                        InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: false).pop();
                          },
                          child: const Icon(FontAwesomeIcons.xmark, size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RText(
                      title: '${history['trang_thai']}:',
                      type: RTextType.text,
                      fontWeight: FontWeight.bold,
                      alignment: Alignment.centerLeft,
                    ),
                    RIconText(title: history['created'] ?? '', icon: FontAwesomeIcons.calendarDays, type: RTextType.label),
                    RText(
                      title: '${history['noi_dung']}',
                      type: RTextType.text,
                      alignment: Alignment.centerLeft,
                    ),
                    RTextField(
                      label: 'Nội dung trả lời',
                      controller: replyContentController,
                      type: RTextFieldType.multiline,
                    ),
                    RButton(
                      text: 'Gửi phản hồi',
                      onPressed: () {
                        BlocProvider.of<BlocRequest>(context).add(BlocReplyAdminRequestEvent(
                          user: widget.user,
                          id: widget.id,
                          replyContent: replyContentController.text,
                        ));
                      },
                      radius: 5,
                    ),
                  ],
                );
              },
              alignment: MainAxisAlignment.end,
            ),
        ],
      ),
    );
  }

  void _loadFormData() {
    BlocProvider.of<BlocRequest>(context).add(BlocLoadRequestDetailEvent(
      user: widget.user,
      id: widget.id,
    ));
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
