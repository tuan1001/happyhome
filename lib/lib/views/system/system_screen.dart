// ignore_for_file: use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rcore/bloc/user/bloc_user.dart';
import 'package:rcore/models/user.dart';
import 'package:rcore/utils/r-layout/sub_layout.dart';
import 'package:rcore/utils/r-navigator/navigator.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/views/about_us/about_us_screen.dart';
import 'package:rcore/views/account/account_screen.dart';
import 'package:rcore/views/system/document_list_screen.dart';
import 'package:rcore/views/system/real_estate_list_video_screen.dart';
import 'package:rcore/views/system/rule_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/r-dialog/yes_no_dialog.dart';
import '../../utils/r-snackbar/snackbar.dart';
import '../landing/login_screen.dart';

class SystemScreen extends StatefulWidget {
  final User user;
  const SystemScreen({super.key, required this.user});

  @override
  State<SystemScreen> createState() => _SystemScreenState();
}

class _SystemScreenState extends State<SystemScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  //* Form size
  Size formSize = const Size(0, 0);

  @override
  Widget build(BuildContext context) {
    formSize = MediaQuery.of(context).size;
    return BlocListener<BlocUser, BlocUserState>(
      listener: (context, state) async {
        if (state is BlocUserError) {
          showRToast(message: state.message, type: ToastType.warning);
        }
        if (state is BlocUserDeactiveAccountSuccess) {
          showRToast(message: state.message, type: ToastType.success);
          Navigator.of(context, rootNavigator: false).pop();
          newScreen(const LoginScreen(), context);
        }
        if (state is BlocUserLogOutSuccess) {
          newScreen(const LoginScreen(), context);
          await _clearInfo();
        }
      },
      child: RSubLayout(
        user: widget.user,
        globalKey: globalKey,
        bottomNavIndex: 4,
        contenPadding: EdgeInsets.zero,
        title: 'H??? th???ng',
        body: _buildBody(formSize),
      ),
    );
  }

  Future<void> _clearInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userName');
    prefs.remove('password');
    prefs.remove('auto_login');
    prefs.clear();
  }

  List<Widget> _buildBody(Size size) {
    return [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/system_backgroud.png'),
            fit: BoxFit.cover,
          ),
        ),
        height: size.height - 83.7 - size.width * .155,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSystemButton(
                  img: 'lib/assets/icons/video.svg',
                  title: 'H???C VIDEO BDS',
                  size: formSize,
                  onTap: () {
                    debugPrint('H???c video BDS');
                    toScreen(RealEstateListVideoScreen(user: widget.user), context);
                  },
                ),
                _buildSystemButton(
                  img: 'lib/assets/icons/document.svg',
                  title: 'T??I LI???U H???C B??S',
                  size: formSize,
                  onTap: () {
                    toScreen(DocumentListScreen(user: widget.user), context);
                  },
                ),
                _buildSystemButton(
                  img: 'lib/assets/icons/question.svg',
                  title: 'N???I QUY, C?? CH???',
                  size: formSize,
                  onTap: () {
                    toScreen(RuleScreen(user: widget.user), context);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSystemButton(img: 'lib/assets/icons/transaction.svg', title: 'R??T XU', size: formSize, onTap: () {}),
                _buildSystemButton(
                  img: 'lib/assets/icons/email.svg',
                  title: 'LI??N H???',
                  size: formSize,
                  onTap: () {
                    toScreen(AboutUsScreen(user: widget.user), context);
                  },
                ),
                _buildSystemButton(
                  img: 'lib/assets/icons/user.svg',
                  title: 'TH??NG TIN C?? NH??N',
                  size: formSize,
                  onTap: () {
                    toScreen(AccountScreen(user: widget.user), context);
                  },
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: _buildSystemButton(
                img: 'lib/assets/icons/heart.svg',
                title: 'T??? X??A T??I KHO???N',
                size: formSize,
                onTap: () {
                  showRYesNoDialog(
                    context,
                    'V?? hi???u h??a t??i kho???n',
                    'M???t khi v?? hi???u h??a, d??? li???u c???a b???n s??? b??? x??a tr??n h??? th???ng v?? kh??ng th??? ho??n t??c. B???n ch???c ch???n mu???n th???c hi???n ?',
                    () {
                      BlocProvider.of<BlocUser>(context).add(BlocUserDeavtiveUserAccountEvent(userInfo: widget.user));
                    },
                    () {
                      Navigator.of(context, rootNavigator: false).pop();
                    },
                  );
                },
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: _buildSystemButton(
                  img: 'lib/assets/icons/logout.svg',
                  title: '',
                  size: formSize,
                  onTap: () {
                    showRYesNoDialog(
                      context,
                      'C???nh b??o',
                      'B???n c?? mu???n ????ng xu???t ?',
                      () async {
                        String? token = await FirebaseMessaging.instance.getToken();
                        BlocProvider.of<BlocUser>(context).add(BlocUserLogOutEvent(deviceToken: token!, userInfo: widget.user));
                      },
                      () {
                        Navigator.of(context, rootNavigator: false).pop();
                      },
                      isDialogPopYes: true,
                    );
                  }),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildSystemButton({
    required Size size,
    required String img,
    String? title,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            padding: const EdgeInsets.all(14),
            width: size.width * 0.3 - 42,
            height: size.width * 0.3 - 42,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(175, 75, 2, 1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: SvgPicture.asset(
              img,
              width: size.width * 0.3 - 30,
              height: size.width * 0.3 - 30,
              color: Colors.white,
            ),
          ),
          if (title != null) SizedBox(width: size.width * 0.3 - 42, child: RText(title: title, align: TextAlign.center)),
        ],
      ),
    );
  }
}
