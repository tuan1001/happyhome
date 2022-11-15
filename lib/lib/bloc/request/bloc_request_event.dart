part of 'bloc_request.dart';

abstract class BlocRequestEvent {
  const BlocRequestEvent();
}

class BlocLoadListRequestsEvent extends BlocRequestEvent {
  final User user;
  String? searchContent;
  String? fromDate;
  String? toDate;
  int? page;
  BlocLoadListRequestsEvent({
    required this.user,
    this.searchContent,
    this.fromDate,
    this.toDate,
    this.page,
  });
}

class BlocAddRequestEvent extends BlocRequestEvent {
  final User user;
  final String title;
  final String requestContent;
  const BlocAddRequestEvent({
    required this.user,
    required this.title,
    required this.requestContent,
  });
}

class BlocLoadRequestDetailEvent extends BlocRequestEvent {
  final User user;
  final int id;
  const BlocLoadRequestDetailEvent({
    required this.user,
    required this.id,
  });
}

class BlocReplyAdminRequestEvent extends BlocRequestEvent {
  final User user;
  final String replyContent;
  final int id;
  const BlocReplyAdminRequestEvent({
    required this.user,
    required this.replyContent,
    required this.id,
  });
}

class BlocUpdateRequestEvent extends BlocRequestEvent {
  final User user;
  final String title;
  final String requestContent;
  final int id;
  const BlocUpdateRequestEvent({
    required this.user,
    required this.title,
    required this.requestContent,
    required this.id,
  });
}

class BlocDeleteRequestEvent extends BlocRequestEvent {
  final User user;
  final int id;
  const BlocDeleteRequestEvent({
    required this.user,
    required this.id,
  });
}

class BlocCloseRequestEvent extends BlocRequestEvent {
  final User user;
  final int id;
  const BlocCloseRequestEvent({
    required this.user,
    required this.id,
  });
}
