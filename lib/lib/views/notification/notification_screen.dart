// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:rcore/bloc/user/bloc_user.dart';
import 'package:rcore/utils/r-button/round_button.dart';
import 'package:rcore/utils/r-dialog/dialog.dart';
import 'package:rcore/utils/r-layout/sub_layout.dart';
import 'package:rcore/utils/r-snackbar/snackbar.dart';
import 'package:rcore/utils/r-text/icon_text.dart';
import 'package:rcore/utils/r-textfield/textfield.dart';
import 'package:rcore/utils/r-textfield/type.dart';

import '../../models/user.dart';
import '../../utils/color/theme.dart';
import '../../utils/r-text/title.dart';
import '../../utils/r-text/type.dart';

class NotificationScreen extends StatefulWidget {
  // final ReceivedNotification? receivedNotification;
  final User userInfo;
  const NotificationScreen({
    Key? key,
    required this.userInfo,
    // this.receivedNotification,
  }) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  bool showDemo = true;

  //* Form controller
  TextEditingController feedbackContentController = TextEditingController();
  TextEditingController notificationContentController = TextEditingController();

  //* Load list notification
  List<dynamic> listNotification = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlocUser, BlocUserState>(
      listener: (context, state) {
        setState(() {
          showDemo = state is! BlocUserLoading;
        });

        if (state is BlocUserSentNotificationSuccess) {
          // AwesomeNotifications().createNotification(
          //   content: NotificationContent(
          //     id: 10,
          //     channelKey: 'basic_channel',
          //     title: 'Thông báo',
          //     body: state.data['message'],
          //   ),
          // );
          showRToast(message: state.message);
          Navigator.of(context, rootNavigator: false).pop();
        }

        if (state is BlocUserLoadListNotificationSuccess) {
          listNotification = state.data;
        }
      },
      child: RSubLayout(
        globalKey: globalKey,
        showBottomNavBar: false,
        title: 'Thông báo',
        backgroundColor: const Color.fromRGBO(235, 235, 237, 1),
        contenPadding: EdgeInsets.zero,
        appBar: _buildAppbar(context),
        body: _buildBody(context),
      ),
    );
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Align(
        alignment: Alignment.center,
        child: RText(
          title: 'THÔNG BÁO',
          type: RTextType.header1,
          color: Colors.white,
        ),
      ),
      backgroundColor: themeColor,
      iconTheme: const IconThemeData(color: Colors.white),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            showRDiaLog(context, [
              const RText(title: 'Thông báo', type: RTextType.title, color: Colors.black),
              RTextField(label: 'Nội dung', controller: notificationContentController, type: RTextFieldType.multiline),
              RButton(
                onPressed: () {
                  BlocProvider.of<BlocUser>(context).add(BlocUserSentNotificationEvent(
                    userInfo: widget.userInfo,
                    content: notificationContentController.text,
                  ));
                },
                text: 'Gửi thông báo',
                radius: 5,
              ),
            ]);
          },
          icon: const Icon(FontAwesomeIcons.facebookMessenger),
        ),
      ],
    );
  }

  List<Widget> _buildBody(BuildContext context) {
    return [
      showDemo != true
          ? const Align(
              child: RText(title: 'Hiện chưa có thông báo nào', type: RTextType.title),
            )
          : Container(
              // margin: EdgeInsets.zero,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(235, 235, 237, 1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Column(
                children: [
                  if (listNotification.isNotEmpty)
                    ...List.generate(
                      listNotification.length,
                      (index) => _buildNotificationItem(context, notiData: listNotification[index]),
                    )
                ],
              ),
            ),
    ];
  }

  Container _buildNotificationItem(BuildContext context, {required Map<String, dynamic> notiData}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 3),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(254, 254, 254, 1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          RIconText(
            title: '${notiData['created']} - ${notiData['timed']}',
            icon: FontAwesomeIcons.calendarDays,
            type: RTextType.title,
            color: themeColor,
          ),
          ...List.generate(
            3,
            (index) => InkWell(
              onTap: () {
                showRDiaLog(context, [
                  const RText(title: 'Phản hồi thông báo', type: RTextType.title, color: Colors.black),
                  RTextField(
                    label: 'Nội dung thông báo',
                    controller: notificationContentController,
                    type: RTextFieldType.multiline,
                    readOnly: true,
                  ),
                  RTextField(label: 'Phản hồi', controller: feedbackContentController, type: RTextFieldType.multiline),
                  RButton(
                    onPressed: () {
                      BlocProvider.of<BlocUser>(context).add(BlocUserSentNotificationEvent(
                        userInfo: widget.userInfo,
                        content: feedbackContentController.text,
                      ));
                    },
                    text: 'Gửi phản hồi',
                    radius: 5,
                  ),
                ]);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 3),
                  RIconText(
                    title: '${notiData['user_id']}',
                    icon: FontAwesomeIcons.bell,
                    type: RTextType.subtitle,
                  ),
                  RIconText(
                    icon: FontAwesomeIcons.noteSticky,
                    maxLines: 2,
                    width: MediaQuery.of(context).size.width - 75,
                    title: '${notiData['noi_dung']}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
