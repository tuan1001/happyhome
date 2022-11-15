import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../controller/auth_controller.dart';
import '../../../models/user.dart';
part 'bloc_auth_event.dart';
part 'bloc_auth_state.dart';

class BlocAuth extends Bloc<BlocAuthEvents, BlocAuthState> {
  final BuildContext context;
  BlocAuth({required this.context}) : super(const BlocAuthInit()) {
    //BlocLoginEvent
    on<BlocAuthLoginEvent>((event, emit) async {
      if (event.username.isEmpty) {
        emit(BlocAuthError(message: 'Vui lòng điền tên đăng nhập!'));
        return;
      }
      if (event.password.isEmpty) {
        emit(BlocAuthError(message: 'Vui lòng điền mật khẩu!'));
        return;
      }
      emit(BlocAuthLoading());
      Map<String, dynamic>? data = await login(context: context, username: event.username, password: event.password, deviceToken: event.deviceToken);
      if (data != null) {
        emit(BlocAuthLoginSuccess(user: User.fromMap(data['data'])));
        return;
      } else {
        emit(BlocAuthLoginFaild());
      }
      emit(const BlocAuthInit());
    });
    //BlocForgotPasswordEvent
    on<BlocAuthForgotPasswordEvent>(
      (event, emit) async {
        if (event.phone.isEmpty) {
          emit(BlocAuthError(message: 'Vui lòng điền số điện thoại'));
          return;
        }
        emit(BlocAuthLoading());
        Map<String, dynamic>? data = await forgotPassword(context: context, phone: event.phone);
        if (data != null) {
          emit(BlocAuthForgotPasswordSent(message: data['message']));
          return;
        }
        emit(const BlocAuthInit());
      },
    );

    on<BlocAuthRegisterEvent>(
      (event, emit) async {
        if (event.comfirmPass != event.password) {
          emit(BlocAuthError(message: 'Mật khẩu không trùng khớp'));
          return;
        }
        emit(BlocAuthLoading());
        Map<String, dynamic>? data = await register(
          context: context,
          phone: event.userPhone,
          password: event.password,
          invitedCode: event.inviteCode,
          name: event.name,
          branchID: event.branchID,
        );
        if (data != null) {
          emit(BlocAuthRegisterSuccess(message: data['message'], user: User.fromMap(data['data'])));
          return;
        }
        emit(const BlocAuthInit());
      },
    );

    on<BlocAuthChangePasswordEvent>((event, emit) async {
      if (event.oldPass.isEmpty) {
        emit(BlocAuthError(message: 'Vui lòng điền mật khẩu!'));
        return;
      }
      if (event.newPass.isEmpty) {
        emit(BlocAuthError(message: 'Vui lòng điền mật khẩu mới!'));
        return;
      }
      if (event.newPass != event.confirmPassword) {
        emit(BlocAuthError(message: 'Mật khẩu mới không khớp!'));
        return;
      }
      emit(BlocAuthLoading());
      Map<String, dynamic>? data = await changeUserPassword(
        context: context,
        userInfo: event.userInfo,
        oldPassword: event.oldPass,
        newPassword: event.newPass,
      );
      if (data != null) {
        emit(BlocAuthChangePasswordSuccess(message: data['message']));
        return;
      }
      emit(const BlocAuthInit());
    });

    //BlocCheckOtpEvent
    on<BlocAuthCheckOtpEvent>(
      (event, emit) async {
        if (event.keyOtp.isEmpty) {
          emit(BlocAuthError(message: 'Vui lòng nhập mã OTP'));
          return;
        }
        emit(BlocAuthLoading());
        Map<String, dynamic>? data = await checkOtp(context: context, email: event.keyOtp, keyOtp: event.keyOtp);
        if (data != null) {
          emit(BlocAuthCheckOTPSuccess(key: data['key'], message: data['message']));
          return;
        }
        emit(const BlocAuthInit());
      },
    );
  }
}
