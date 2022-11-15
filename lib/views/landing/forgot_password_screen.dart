// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rcore/bloc/auth/bloc/bloc_auth.dart';
import 'package:rcore/utils/r-button/round_button.dart';
import 'package:rcore/utils/r-layout/landing_layout.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/utils/r-text/type.dart';
import 'package:rcore/utils/r-textfield/textfield_default.dart';
import 'package:rcore/utils/r-textfield/type.dart';

import '../../utils/r-dialog/notification_dialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  bool loadingOverlay = false;
  //Init variables
  TextEditingController userPhoneController = TextEditingController();
  FocusNode buttonFocusNode = FocusNode();
  bool isFocus = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<BlocAuth, BlocAuthState>(
      listener: (context, state) {
        if (state is BlocAuthError) {
          showRNotificationDialog(context, 'Thông báo', state.message);
        }
        if (state is BlocAuthForgotPasswordSent) {
          showRNotificationDialog(context, 'Thông báo', state.message, customFunction: () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }
      },
      child: RLandingLayout(
        globalKey: _globalKey,
        body: _buildBody(context),
        bottomTextOnPressed: () {
          Navigator.pop(context);
        },
        bottomText: 'Quay lại đăng nhập!',
        overlayLoading: loadingOverlay,
      ),
    );
  }

  List<Widget> _buildBody(BuildContext context) {
    return [
      RText(title: 'Quên mật khẩu', type: RTextType.title),
      RTextFieldDefault(
          label: 'Số điện thoại',
          maxLength: 10,
          controller: userPhoneController,
          type: RTextFieldType.number,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(buttonFocusNode);
            isFocus = false;
          }),
      RButton(
          focusNode: buttonFocusNode,
          onFocused: (value) {
            if (!isFocus) {
              isFocus = true;
              BlocProvider.of<BlocAuth>(context).add(BlocAuthForgotPasswordEvent(phone: userPhoneController.text));
            }
          },
          text: 'Xác nhận',
          onPressed: () {
            BlocProvider.of<BlocAuth>(context).add(BlocAuthForgotPasswordEvent(phone: userPhoneController.text));
          },
          radius: 100,
          styled: true),
    ];
  }
}
