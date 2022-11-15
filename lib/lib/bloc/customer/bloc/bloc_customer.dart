import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rcore/controller/customer_controller.dart';
import 'package:rcore/models/customer.dart';
import 'package:rcore/models/user.dart';

part 'bloc_customer_event.dart';
part 'bloc_customer_state.dart';

class BlocCustomer extends Bloc<CustomerEvent, BlocCustomerState> {
  final BuildContext context;
  BlocCustomer({required this.context}) : super(const BlocCustomerInitial()) {
    on<BlocCustomerLoadListEvent>((event, emit) async {
      emit(const BlocCustomerLoading());
      Map<String, dynamic>? data = await getListRequestCustomer(
        context: context,
        user: event.userInfo,
        keySearch: event.keySearch,
        page: event.page,
        active: event.active,
      );
      if (data != null) {
        List<Customer> res = [];
        for (var element in data['data'] as List) {
          res.add(Customer.fromMap(element));
        }
        emit(BlocCustomerLoadListSuccess(
          listCustomer: res,
          statistic: data['tong_quan'] ?? {},
          page: data['nowpage'] ?? 1,
          maxPage: data['allpage'] ?? 1,
        ));
      }
      emit(const BlocCustomerInitial());
    });

    on<BlocCustomerLoadCoinEvent>((event, emit) async {
      emit(const BlocCustomerLoading());
      Map<String, dynamic>? data = await getRequestCoinCustomer(context: context, user: event.userInfo);
      if (data != null) {
        emit(BlocCustomerLoadCoinSuccess(coin: int.parse(data['so_du']), rose: data['hoa_hong']));
      }
      emit(const BlocCustomerInitial());
    });

    on<BlocCustomerCreateEvent>((event, emit) async {
      if (event.name.isEmpty) {
        emit(BlocCustomerError(message: 'Tên khách hàng không được để trống'));
        return;
      }

      if (event.phone.isEmpty) {
        emit(BlocCustomerError(message: 'Số điện thoại không được để trống'));
        return;
      }

      emit(const BlocCustomerLoading());
      Map<String, dynamic>? data = await createRequestCustomer(
        context: context,
        userInfo: event.userInfo,
        name: event.name,
        phone: event.phone,
        note: event.note,
      );
      if (data != null) {
        emit(BlocCustomerCreateSuccess(message: data['message']));
      }
      emit(const BlocCustomerInitial());
    });

    on<BlocCustomerDetailEvent>((event, emit) async {
      emit(const BlocCustomerLoading());
      Map<String, dynamic>? data = await getRequestCustomerDetail(context: context, user: event.userInfo, id: event.id);
      if (data != null) {
        emit(BlocCustomerLoadDetailsSuccess(customerData: data, id: event.id));
      }
      emit(const BlocCustomerInitial());
    });

    on<BlocCustomerUpdateEvent>((event, emit) async {
      emit(const BlocCustomerLoading());
      Map<String, dynamic>? data = await updateRequestCustomerInfo(
        context: context,
        userInfo: event.userInfo,
        id: event.id,
        name: event.name,
        phone: event.phone,
        note: event.note,
      );
      if (data != null) {
        emit(BlocCustomerUpdateSuccess(message: data['message']));
      }
      emit(const BlocCustomerInitial());
    });

    on<BlocCustomerUpdateDetailEvent>((event, emit) async {
      emit(const BlocCustomerLoading());
      Map<String, dynamic>? data = await updateDetailsRequestCustomerInfo(
        context: context,
        userInfo: event.userInfo,
        id: event.id,
        name: event.name,
        phone: event.phone,
        note: event.note,
      );
      if (data != null) {
        emit(BlocCustomerUpdateDetailSuccess(message: data['message'], customerData: data['update']));
      }
      emit(const BlocCustomerInitial());
    });

    on<BlocCustomerDeleteEvent>((event, emit) async {
      emit(const BlocCustomerLoading());
      Map<String, dynamic>? data = await deleteRequestCustomer(context: context, user: event.userInfo, id: event.id);
      if (data != null) {
        emit(BlocCustomerDeleteSuccess(message: data['message']));
      }
      emit(const BlocCustomerInitial());
    });
  }
}
