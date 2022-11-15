import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rcore/controller/user_controller.dart';

import '../../models/user.dart';

part 'bloc_user_event.dart';
part 'bloc_user_state.dart';

class BlocUser extends Bloc<BlocUserEvent, BlocUserState> {
  BuildContext context;
  BlocUser({required this.context}) : super(BlocUserInitial()) {
    on<BlocLoadUserRoseEvent>(
      (event, emit) async {
        emit(BlocUserLoading());
        Map<String, dynamic>? data = await getUserRose(
          context: context,
          userInfo: event.userInfo,
          fromDate: event.dateFrom,
          toDate: event.dateTo,
          page: event.page ?? 1,
        );
        if (data != null) {
          emit(BlocUserLoadedRose(
            dataRose: data['lich_su_giao_dich'],
            dataCoin: data['lich_su_tich_xu'],
            totalRose: int.parse(data['tong'] ?? '0'),
            totalCoin: int.parse(data['tong_xu'] ?? '0'),
          ));
        }
        emit(BlocUserInitial());
      },
    );

    on<BlocUserSentNotificationEvent>(
      (event, emit) async {
        emit(BlocUserLoading());
        Map<String, dynamic>? data = await sentNotification(
          context: context,
          userInfo: event.userInfo,
          content: event.content,
        );
        if (data != null) {
          emit(BlocUserSentNotificationSuccess(message: data['message']));
        }
        emit(BlocUserInitial());
      },
    );

    on<BlocLoadUserListNotification>(
      (event, emit) async {
        emit(BlocUserLoading());
        Map<String, dynamic>? data = await sentNotification(
          context: context,
          userInfo: event.userInfo,
          content: event.content,
        );
        if (data != null) {
          emit(BlocUserLoadListNotificationSuccess(data: data['thong_bao']));
        }
        emit(BlocUserInitial());
      },
    );

    on<BlocLoadUserStatisticalEvent>(
      (event, emit) async {
        emit(BlocUserLoading());
        Map<String, dynamic>? data = await getUserStatistial(
          context: context,
          userInfo: event.user,
          fromDate: event.fromDate,
          toDate: event.toDate,
        );
        if (data != null) {
          emit(BlocUserStatisticalLoaded(data: data['data']));
        }
        emit(BlocUserInitial());
      },
    );

    on<BlocUpdateUserInfoEvent>(
      (event, emit) async {
        emit(BlocUserLoading());
        if (event.name == '') {
          emit(const BlocUserError(message: 'Vui lòng nhập tên'));
          return;
        }
        if (event.email == '') {
          emit(const BlocUserError(message: 'Vui lòng nhập tên'));
          return;
        }
        Map<String, dynamic>? data = await updateUserInfo(
          context: context,
          userInfo: event.userInfo,
          name: event.name,
          email: event.email,
          avatarBase64: event.avatarBase64,
        );
        if (data != null) {
          emit(BlocUserChangeInfoSuccess(message: data['message'], user: User.fromMap(data['data'])));
        }
        emit(BlocUserInitial());
      },
    );

    on<BlocUserLogOutEvent>(
      (event, emit) async {
        emit(BlocUserLoading());
        Map<String, dynamic>? data = await userLogOut(
          context: context,
          userInfo: event.userInfo,
          deviceToken: event.deviceToken,
        );
        if (data != null) {
          emit(BlocUserLogOutSuccess(message: data['message']));
        }
        emit(BlocUserInitial());
      },
    );

    on<BlocUserDeavtiveUserAccountEvent>(
      (event, emit) async {
        emit(BlocUserLoading());
        Map<String, dynamic>? data = await deactiveUserAccount(
          context: context,
          userInfo: event.userInfo,
        );
        if (data != null) {
          emit(BlocUserDeactiveAccountSuccess(message: data['message']));
        }
        emit(BlocUserInitial());
      },
    );
  }
}
