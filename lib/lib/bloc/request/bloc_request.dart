import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:rcore/controller/request_controller.dart';

import '../../models/request.dart';
import '../../models/user.dart';

part 'bloc_request_event.dart';
part 'bloc_request_state.dart';

class BlocRequest extends Bloc<BlocRequestEvent, BlocRequestState> {
  BuildContext context;

  BlocRequest({required this.context}) : super(BlocRequestInitial()) {
    on<BlocLoadListRequestsEvent>((event, emit) async {
      emit(BlocRequestLoadingState());
      Map<String, dynamic>? data = await loadListRequest(
        context: context,
        user: event.user,
        fromDate: event.fromDate,
        toDate: event.toDate,
        searchContent: event.searchContent,
        page: event.page ?? 1,
      );
      if (data != null) {
        List<Request> requests = [];
        for (var element in data['data'] as List) {
          requests.add(Request.fromMap(element));
        }
        emit(BlocListRequestsLoadedSuccessState(requests: requests, maxPage: data['metaPage'], page: data['perPage']));
      }
      emit(BlocRequestInitial());
    });

    on<BlocLoadRequestDetailEvent>((event, emit) async {
      emit(BlocRequestLoadingState());
      Map<String, dynamic>? data = await loadRequestDetail(
        context: context,
        user: event.user,
        id: event.id,
      );
      if (data != null) {
        emit(BlocLoadRequestDetailState(request: data['data']));
      }
      emit(BlocRequestInitial());
    });

    on<BlocAddRequestEvent>((event, emit) async {
      emit(BlocRequestLoadingState());
      Map<String, dynamic>? data = await addRequest(
        context: context,
        user: event.user,
        title: event.title,
        requestContent: event.requestContent,
      );
      if (data != null) {
        emit(BlocRequestAddedState(message: data['message']));
      }
      emit(BlocRequestInitial());
    });

    on<BlocUpdateRequestEvent>((event, emit) async {
      emit(BlocRequestLoadingState());
      Map<String, dynamic>? data = await updateRequest(
        context: context,
        user: event.user,
        id: event.id,
        title: event.title,
        requestContent: event.requestContent,
      );
      if (data != null) {
        emit(BlocRequestUpdatedState(message: data['message'], request: data['data']));
      }
      emit(BlocRequestInitial());
    });

    on<BlocDeleteRequestEvent>((event, emit) async {
      emit(BlocRequestLoadingState());
      Map<String, dynamic>? data = await deleteRequest(
        context: context,
        user: event.user,
        id: event.id,
      );
      if (data != null) {
        emit(BlocRequestDeletedState(message: data['message']));
      }
      emit(BlocRequestInitial());
    });

    on<BlocCloseRequestEvent>((event, emit) async {
      emit(BlocRequestLoadingState());
      Map<String, dynamic>? data = await closeRequest(
        context: context,
        user: event.user,
        id: event.id,
      );
      if (data != null) {
        emit(BlocRequestClosedState(message: data['message']));
      }
      emit(BlocRequestInitial());
    });

    on<BlocReplyAdminRequestEvent>((event, emit) async {
      emit(BlocRequestLoadingState());
      Map<String, dynamic>? data = await replyAdminRequest(
        context: context,
        user: event.user,
        id: event.id,
        replyContent: event.replyContent,
      );
      if (data != null) {
        emit(BlocRequestReplyAdminState(message: data['message'], request: data['data']));
      }
      emit(BlocRequestInitial());
    });
  }
}
