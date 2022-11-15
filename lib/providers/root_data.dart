import 'package:flutter/material.dart';

class RootModel extends ChangeNotifier {
  //* UserInfo
  Map<String, dynamic> _userInfo = {};
  getUserInfo() => _userInfo;
  setUserInfo(Map<String, dynamic> userInfo) => _userInfo = userInfo;
}
