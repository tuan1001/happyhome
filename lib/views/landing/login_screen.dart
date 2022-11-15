import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rcore/bloc/auth/bloc/bloc_auth.dart';
import 'package:rcore/utils/r-button/round_button.dart';
import 'package:rcore/utils/r-button/text_button.dart';
import 'package:rcore/utils/r-layout/landing_layout.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/utils/r-textfield/textfield_default.dart';
import 'package:rcore/utils/r-textfield/type.dart';
import 'package:rcore/views/customer/main_customer_screen.dart';
import 'package:rcore/views/landing/forgot_password_screen.dart';
import 'package:rcore/views/landing/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/r-dialog/notification_dialog.dart';
import '../../utils/r-navigator/navigator.dart';
import '../../utils/r-text/type.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  bool overlayLoading = false;
  // Init Variable
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode buttonFocusNode = FocusNode();
  bool isFocus = false;
  String appVersion = '';
  String deviceToken = '';

  @override
  void initState() {
    _getToken();

    super.initState();
  }

  _getToken() async {
    deviceToken = (await FirebaseMessaging.instance.getToken())!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlocAuth, BlocAuthState>(
      listener: (context, state) {
        if (state is BlocAuthLoading) {
          setState(() {
            overlayLoading = true;
          });
        } else {
          setState(() {
            overlayLoading = false;
          });
        }
        if (state is BlocAuthError) {
          showRNotificationDialog(context, 'Thông báo', state.message);
        }
        if (state is BlocAuthLoginSuccess) {
          newScreen(MainCustomerScreen(user: state.user), context);
        }
      },
      child: RLandingLayout(
        globalKey: _globalKey,
        bottomText: 'Chưa có tài khoản? Đăng ký!',
        bottomTextOnPressed: () {
          newScreen(const RegisterScreen(), context);
        },
        overlayLoading: overlayLoading,
        body: _buildBody(context),
      ),
    );
  }

  List<Widget> _buildBody(BuildContext context) {
    return [
      const RText(title: 'Đăng nhập cộng tác viên', type: RTextType.title),
      RTextFieldDefault(
        label: 'Số điện thoại',
        maxLength: 10,
        controller: usernameController,
        type: RTextFieldType.number,
      ),
      RTextFieldDefault(
          label: 'Mật khẩu',
          controller: passwordController,
          type: RTextFieldType.password,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(buttonFocusNode);
            isFocus = false;
          }),
      RTextButton(
          text: 'Quên mật khẩu?',
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
          },
          type: RTextType.subtitle,
          alignment: MainAxisAlignment.end),
      RButton(
          focusNode: buttonFocusNode,
          onFocused: (value) {
            if (!isFocus) {
              _loginPressed();
            }
            isFocus = true;
          },
          text: 'Đăng nhập',
          onPressed: _loginPressed,
          radius: 100,
          styled: true)
    ];
  }

  _loginPressed() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('auto_login', 'true');
      prefs.setString('username', usernameController.text);
      prefs.setString('password', passwordController.text);
    });
    BlocProvider.of<BlocAuth>(context).add(
      BlocAuthLoginEvent(
        username: usernameController.text,
        password: passwordController.text,
        deviceToken: deviceToken,
      ),
    );
  }
}
