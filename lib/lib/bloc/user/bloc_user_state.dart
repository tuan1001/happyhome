part of 'bloc_user.dart';

abstract class BlocUserState extends Equatable {
  const BlocUserState();

  @override
  List<Object> get props => [];
}

/// BlocUserInitial is a class that extends BlocUserState
class BlocUserInitial extends BlocUserState {}

/// BlocUserLoading is a subclass of BlocUserState
class BlocUserLoading extends BlocUserState {}

/// BlocUserError is a BlocUserState that has a message
class BlocUserError extends BlocUserState {
  final String message;
  const BlocUserError({required this.message});
}

/// `BlocUserLoadedRose` is a subclass of `BlocUserState` that has a `data` property of type
/// `Map<String, dynamic>?`
class BlocUserLoadedRose extends BlocUserState {
  final List<dynamic> dataRose;
  final List<dynamic> dataCoin;
  final int? totalRose;
  final int? totalCoin;
  const BlocUserLoadedRose({required this.dataRose, required this.dataCoin, this.totalRose, this.totalCoin});
}

class BlocUserStatisticalLoaded extends BlocUserState {
  final Map<String, dynamic> data;
  const BlocUserStatisticalLoaded({required this.data});
}

class BlocUserSentNotificationSuccess extends BlocUserState {
  final String message;
  const BlocUserSentNotificationSuccess({required this.message});
}

class BlocUserLoadListNotificationSuccess extends BlocUserState {
  final List<dynamic> data;
  const BlocUserLoadListNotificationSuccess({required this.data});
}

/// `BlocUserChangeInfoSuccess` is a `BlocUserState` that holds a `message` and a `user`
class BlocUserChangeInfoSuccess extends BlocUserState {
  final String message;
  final User user;
  const BlocUserChangeInfoSuccess({required this.message, required this.user});
}

/// > BlocUserChangeInfoSuccess is a BlocUserState that represents the success of a change info request
class BlocUserChangePasswordSuccess extends BlocUserState {
  final String message;
  const BlocUserChangePasswordSuccess({required this.message});
}

/// `BlocUserLogOutSuccess` is a `BlocUserState` that represents a successful logout
class BlocUserLogOutSuccess extends BlocUserState {
  final String message;
  const BlocUserLogOutSuccess({required this.message});
}

/// `BlocUserDeactiveAccountSuccess` is a `BlocUserState` that holds a `message` of type `String`
class BlocUserDeactiveAccountSuccess extends BlocUserState {
  final String message;
  const BlocUserDeactiveAccountSuccess({required this.message});
}
