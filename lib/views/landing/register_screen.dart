import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rcore/bloc/auth/bloc/bloc_auth.dart';
import 'package:rcore/controller/category_controller.dart';
import 'package:rcore/utils/r-button/round_button.dart';
import 'package:rcore/utils/r-dialog/notification_dialog.dart';
import 'package:rcore/utils/r-layout/landing_layout.dart';
import 'package:rcore/utils/r-select/drop_down_select.dart';
import 'package:rcore/utils/r-snackbar/snackbar.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/utils/r-text/type.dart';
import 'package:rcore/utils/r-textfield/textfield_default.dart';
import 'package:rcore/utils/r-textfield/type.dart';

import '../../utils/r-navigator/navigator.dart';
import '../customer/main_customer_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  bool loadingOverlay = false;
  Map<String, dynamic>? selectedValue;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController invitedCodeController = TextEditingController();

  FocusNode buttonFocusNode = FocusNode();
  bool isFocus = false;

  //* loaded Branch
  List<dynamic> listBranch = [];
  Map<String, dynamic> selectedBranch = {};
  bool isLoadedBranch = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    _loadBranchCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlocAuth, BlocAuthState>(
      listener: (context, state) {
        setState(() {
          isLoadedBranch = state is! BlocAuthLoading;
        });
        if (state is BlocAuthError) {
          showRNotificationDialog(context, 'Thông báo', state.message);
        }
        if (state is BlocAuthRegisterSuccess) {
          showRToast(message: state.message);
          newScreen(MainCustomerScreen(user: state.userInfo), context);
        }
      },
      child: RLandingLayout(
        globalKey: _globalKey,
        overlayLoading: !isLoadedBranch,
        body: _buildBody(context),
        bottomText: 'Đã có tài khoản? Đăng nhập!',
        bottomTextOnPressed: () {
          newScreen(const LoginScreen(), context);
        },
      ),
    );
  }

  List<Widget> _buildBody(BuildContext context) {
    return [
      const RText(title: 'Đăng ký cộng tác viên', type: RTextType.title),
      RTextFieldDefault(label: 'Số điện thoại ⁽*⁾', maxLength: 10, controller: phoneNumberController, type: RTextFieldType.number),
      RTextFieldDefault(label: 'Mật khẩu ⁽*⁾', controller: passwordController, type: RTextFieldType.password),
      RTextFieldDefault(label: 'Xác nhận mật khẩu ⁽*⁾', controller: confirmPasswordController, type: RTextFieldType.password),
      RTextFieldDefault(
          label: 'Họ và tên ⁽*⁾',
          controller: fullNameController,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(buttonFocusNode);
            isFocus = false;
          }),
      RTextFieldDefault(label: 'Số điện thoại người giới thiệu', controller: invitedCodeController, type: RTextFieldType.number),
      RDropDownDefault(
        label: 'Chi nhánh ⁽*⁾',
        items: listBranch.isEmpty ? [] : List.generate(listBranch.length, (index) => listBranch[index]),
        onChanged: (value) {
          setState(() {
            selectedBranch = value!;
          });
        },
        // hintText: selectedBranch['ten_chi_nhanh'] ?? 'Chọn chi nhánh',
        currentValue: selectedBranch,
        keyDisplay: 'ten_chi_nhanh',
      ),
      const SizedBox(height: 15),
      RButton(
        focusNode: buttonFocusNode,
        onFocused: (value) {
          if (!isFocus) {
            isFocus = true;
            _loadRegisterFetch();
          }
        },
        text: 'Đăng ký',
        onPressed: _loadRegisterFetch,
        radius: 100,
        styled: true,
      ),
    ];
  }

  _loadRegisterFetch() async {
    BlocProvider.of<BlocAuth>(context).add(
      BlocAuthRegisterEvent(
        userPhone: phoneNumberController.text,
        password: passwordController.text,
        comfirmPass: confirmPasswordController.text,
        name: fullNameController.text,
        inviteCode: invitedCodeController.text,
        branchID: selectedBranch.isNotEmpty ? selectedBranch['id'].toString() : '',
      ),
    );
  }

  _loadBranchCategory() async {
    await getBranchCategory(context: context).then(
      (value) => {
        if (value != null)
          {
            setState(() {
              listBranch = value['data'];
              isLoadedBranch = true;
            })
          }
      },
    );
  }
}
