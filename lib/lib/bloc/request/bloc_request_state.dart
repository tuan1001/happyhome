// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'bloc_request.dart';

abstract class BlocRequestState {
  const BlocRequestState();
}

class BlocRequestInitial extends BlocRequestState {}

class BlocRequestLoadingState extends BlocRequestState {}

class BlocRequestError extends BlocRequestState {
  final String message;
  const BlocRequestError({required this.message});
}

class BlocListRequestsLoadedSuccessState extends BlocRequestState {
  final List<Request> requests;
  final int page;
  final int maxPage;
  const BlocListRequestsLoadedSuccessState({required this.requests, this.page = 1, this.maxPage = 1});
}

class BlocLoadRequestDetailState extends BlocRequestState {
  final Map<String, dynamic> request;
  const BlocLoadRequestDetailState({required this.request});
}

class BlocRequestAddedState extends BlocRequestState {
  final String message;
  const BlocRequestAddedState({required this.message});
}

class BlocRequestReplyAdminState extends BlocRequestState {
  final String message;
  final Map<String, dynamic> request;

  const BlocRequestReplyAdminState({required this.message, required this.request});
}

class BlocRequestUpdatedState extends BlocRequestState {
  final String message;
  final Map<String, dynamic> request;
  const BlocRequestUpdatedState({required this.message, required this.request});
}

class BlocRequestDeletedState extends BlocRequestState {
  final String message;
  const BlocRequestDeletedState({required this.message});
}

class BlocRequestClosedState extends BlocRequestState {
  final String message;
  const BlocRequestClosedState({required this.message});
}
