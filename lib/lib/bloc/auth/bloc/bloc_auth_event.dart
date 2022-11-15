part of 'bloc_auth.dart';

class BlocAuthEvents {
  const BlocAuthEvents();
}

class BlocAuthLoginEvent extends BlocAuthEvents {
  final String username;
  final String password;
  final String deviceToken;
  BlocAuthLoginEvent({
    required this.username,
    required this.password,
    required this.deviceToken,
  });
}

class BlocAuthRegisterEvent extends BlocAuthEvents {
  final String userPhone;
  final String password;
  final String comfirmPass;
  final String inviteCode;
  final String name;
  final String branchID;
  BlocAuthRegisterEvent({
    required this.userPhone,
    required this.password,
    required this.comfirmPass,
    required this.inviteCode,
    required this.name,
    required this.branchID,
  });
}

class BlocAuthForgotPasswordEvent extends BlocAuthEvents {
  final String phone;
  BlocAuthForgotPasswordEvent({required this.phone});
}

class BlocAuthCheckOtpEvent extends BlocAuthEvents {
  final String keyOtp;
  final String email;
  BlocAuthCheckOtpEvent({required this.keyOtp, required this.email});
}

class BlocAuthChangePasswordEvent extends BlocAuthEvents {
  final User userInfo;
  final String newPass;
  final String oldPass;
  final String confirmPassword;
  BlocAuthChangePasswordEvent({
    required this.userInfo,
    required this.oldPass,
    required this.newPass,
    required this.confirmPassword,
  });
}
