part of 'bloc_user.dart';

abstract class BlocUserEvent extends Equatable {
  const BlocUserEvent();

  @override
  List<Object> get props => [];
}

/// `BlocGetUserRoseEvent` is a `BlocUserEvent` that contains a `User` and optional `String`s and `int`s
class BlocLoadUserRoseEvent extends BlocUserEvent {
  final User userInfo;
  final String? dateFrom;
  final String? dateTo;
  final int? page;
  const BlocLoadUserRoseEvent({
    required this.userInfo,
    this.dateFrom,
    this.dateTo,
    this.page,
  });
}

class BlocLoadUserListNotification extends BlocUserEvent {
  final User userInfo;
  final String content;
  const BlocLoadUserListNotification({
    required this.userInfo,
    required this.content,
  });
}

class BlocUserSentNotificationEvent extends BlocUserEvent {
  final User userInfo;
  final String content;
  const BlocUserSentNotificationEvent({
    required this.userInfo,
    required this.content,
  });
}

/// `BlocLoadUserStatisticalEvent` is a `BlocUserEvent` that loads the statistical data of a `User`
class BlocLoadUserStatisticalEvent extends BlocUserEvent {
  final User user;
  final String? fromDate;
  final String? toDate;
  const BlocLoadUserStatisticalEvent({required this.user, this.fromDate, this.toDate});
}

/// `BlocUpdateUserInfoEvent` is a `BlocUserEvent` that contains a `User` and optionally a `name` and
/// `avatarBase64`
class BlocUpdateUserInfoEvent extends BlocUserEvent {
  final User userInfo;
  final String? name;
  final String? email;
  final String? avatarBase64;

  const BlocUpdateUserInfoEvent({
    required this.userInfo,
    this.email,
    this.name,
    this.avatarBase64,
  });
}

/// BlocUserLogOutEvent is a subclass of BlocUserEvent that has a userInfo and deviceToken property
class BlocUserLogOutEvent extends BlocUserEvent {
  final User userInfo;
  final String deviceToken;
  const BlocUserLogOutEvent({required this.userInfo, required this.deviceToken});
}

/// This class is used to deactivate a user account
class BlocUserDeavtiveUserAccountEvent extends BlocUserEvent {
  final User userInfo;
  const BlocUserDeavtiveUserAccountEvent({required this.userInfo});
}
