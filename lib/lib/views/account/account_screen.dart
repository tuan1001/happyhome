// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rcore/bloc/user/bloc_user.dart';
import 'package:rcore/utils/color/theme.dart';
import 'package:rcore/utils/r-button/round_button.dart';
import 'package:rcore/utils/r-button/type.dart';
import 'package:rcore/utils/r-dialog/dialog.dart';
import 'package:rcore/utils/r-dialog/notification_dialog.dart';
import 'package:rcore/utils/r-dialog/yes_no_dialog.dart';
import 'package:rcore/utils/r-navigator/navigator.dart';
import 'package:rcore/utils/r-snackbar/snackbar.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/utils/r-text/type.dart';
import 'package:rcore/utils/r-textfield/textfield.dart';
import 'package:rcore/utils/r-textfield/type.dart';

import '../../bloc/auth/bloc_auth.dart';
import '../../models/user.dart';
import '../../utils/r-layout/sub_layout.dart';
import '../landing/login_screen.dart';

class AccountScreen extends StatefulWidget {
  final User user;
  const AccountScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  bool _overlayLoading = true;

  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Map<String, dynamic> userInfoUpdated = {};
  User userUpdated = User();

  File imageFile = File('');

  String userImg = '';

  Future _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    imageFile = File(image.path);
    setState(() {});
  }

  @override
  void initState() {
    phoneController.text = widget.user.phone!;
    emailController.text = widget.user.email!;
    nameController.text = widget.user.name!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BlocUser, BlocUserState>(listener: (context, state) async {
          setState(() {
            _overlayLoading = state is! BlocUserLoading;
          });
          if (state is BlocUserError) {
            showRToast(message: state.message, type: ToastType.warning);
          }
          if (state is BlocUserChangeInfoSuccess) {
            Future.delayed(const Duration(milliseconds: 500), () {
              replaceScreen(AccountScreen(user: state.user), context);
              showRToast(message: state.message, type: ToastType.success);
            });
          }
          if (state is BlocUserLogOutSuccess) {
            newScreen(const LoginScreen(), context);
            await _clearInfo();
          }
          if (state is BlocUserDeactiveAccountSuccess) {
            showRToast(message: state.message, type: ToastType.success);
            Navigator.of(context, rootNavigator: false).pop();
            newScreen(const LoginScreen(), context);
          }
        }),
        BlocListener<BlocAuth, BlocAuthState>(listener: (context, state) async {
          setState(() {
            _overlayLoading = state is! BlocAuthLoading;
          });
          if (state is BlocAuthError) {
            showRNotificationDialog(context, 'Th??ng b??o', state.message);
          }
          if (state is BlocAuthChangePasswordSuccess) {
            Navigator.of(context, rootNavigator: false).pop();
            await _clearInfo();
            newScreen(const LoginScreen(), context);
            showRToast(message: state.message, type: ToastType.success);
          }
        }),
      ],
      child: RSubLayout(
        user: userUpdated.id == null ? widget.user : userUpdated,
        globalKey: globalKey,
        title: 'T??i kho???n',
        overlayLoading: !_overlayLoading,
        bottomNavIndex: 4,
        enableAction: true,
        body: _buildBody(context),
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

  List<Widget> _buildBody(BuildContext context) {
    return [
      Column(
        children: [
          const Align(alignment: Alignment.centerLeft, child: RText(title: 'S???a th??ng tin t??i kho???n', type: RTextType.title)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                    child: GestureDetector(
                      onTap: () {
                        showRDiaLog(
                          context,
                          [
                            if (imageFile.path != '') Center(child: Image.file(imageFile)),
                            if (widget.user.profileImageUrl != null && imageFile.path == '')
                              Center(child: Image.network('https://homeland.andin.io/images/${widget.user.profileImageUrl}')),
                          ],
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          radius: 52,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade200,
                            radius: 50,
                            backgroundImage: _getImg(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 20,
                    child: RawMaterialButton(
                      onPressed: _pickImage,
                      elevation: 10,
                      fillColor: themeColor.withOpacity(0.9),
                      padding: const EdgeInsets.all(5),
                      shape: const CircleBorder(),
                      child: const Icon(
                        FontAwesomeIcons.camera,
                        size: 15,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          RTextField(label: 'S??? ??i???n tho???i', controller: phoneController, readOnly: true),
          RTextField(label: 'Email', controller: emailController),
          RTextField(label: 'H??? t??n', controller: nameController),
          RButton(
            text: 'L??u th??ng tin',
            onPressed: () {
              BlocProvider.of<BlocUser>(context).add(BlocUpdateUserInfoEvent(
                userInfo: widget.user,
                name: nameController.text,
                email: emailController.text,
                avatarBase64: imageFile.path,
              ));
            },
            radius: 5,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(FontAwesomeIcons.lock),
            title: RText(
              title: '?????i m???t kh???u',
              type: RTextType.subtitle,
              color: rButtonBackground(RButtonType.warning),
            ),
            trailing: const Icon(FontAwesomeIcons.angleRight),
            iconColor: rButtonBackground(RButtonType.warning),
            onTap: () {
              TextEditingController oldPassController = TextEditingController();
              TextEditingController newPassController = TextEditingController();
              TextEditingController confirmNewPassController = TextEditingController();
              showRDiaLog(context, [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 18),
                    const RText(title: '?????I M???T KH???U', type: RTextType.title, color: themeColor),
                    InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: false).pop();
                      },
                      child: const Icon(FontAwesomeIcons.xmark, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                RTextField(label: 'M???t kh???u c??', controller: oldPassController, type: RTextFieldType.password),
                RTextField(label: 'M???t kh???u m???i', controller: newPassController, type: RTextFieldType.password),
                RTextField(label: 'X??c nh???n m???t kh???u m???i', controller: confirmNewPassController, type: RTextFieldType.password),
                RButton(
                  text: '?????i m???t kh???u',
                  onPressed: () {
                    BlocProvider.of<BlocAuth>(context).add(
                      BlocAuthChangePasswordEvent(
                        userInfo: widget.user,
                        oldPass: oldPassController.text,
                        newPass: newPassController.text,
                        confirmPassword: confirmNewPassController.text,
                      ),
                    );
                  },
                  radius: 5,
                ),
              ]);
            },
          ),
          ListTile(
              leading: const Icon(FontAwesomeIcons.xmark),
              title: RText(
                title: 'V?? hi???u h??a',
                type: RTextType.subtitle,
                color: rButtonBackground(RButtonType.danger),
              ),
              trailing: const Icon(FontAwesomeIcons.angleRight),
              iconColor: rButtonBackground(RButtonType.danger),
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
              }),
          ListTile(
            leading: const Icon(FontAwesomeIcons.rightFromBracket),
            title: const RText(
              title: '????ng xu???t',
              type: RTextType.subtitle,
            ),
            trailing: const Icon(FontAwesomeIcons.angleRight),
            iconColor: Colors.black,
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
            },
          ),
        ],
      )
    ];
  }

  _getImg() {
    if (widget.user.profileImageUrl == null) {
      return imageFile.path == '' ? null : FileImage(File(imageFile.path));
    }
    if (imageFile.path != '') return FileImage(File(imageFile.path));
    return NetworkImage('https://homeland.andin.io/images/${widget.user.profileImageUrl}');
  }
}
