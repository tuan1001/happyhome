part of 'bloc_auth.dart';

class BlocAuthState {
  const BlocAuthState();
}

class BlocAuthError extends BlocAuthState {
  final String message;
  BlocAuthError({required this.message});
}

class BlocAuthLoginSuccess extends BlocAuthState {
  final User user;
  BlocAuthLoginSuccess({required this.user});
}

class BlocAuthInit extends BlocAuthState {
  const BlocAuthInit();
}

class BlocAuthLoading extends BlocAuthState {}

class BlocAuthForgotPasswordSent extends BlocAuthState {
  final String message;
  BlocAuthForgotPasswordSent({required this.message});
}

class BlocAuthCheckOTPSuccess extends BlocAuthState {
  final String message;
  final String key;
  BlocAuthCheckOTPSuccess({required this.key, required this.message});
}

class BlocAuthRegisterSuccess extends BlocAuthState {
  final String message;
  final User userInfo;
  BlocAuthRegisterSuccess({required this.message, required this.userInfo});
}

class BlocAuthChangePasswordSuccess extends BlocAuthState {
  final String message;
  BlocAuthChangePasswordSuccess({required this.message});
}
