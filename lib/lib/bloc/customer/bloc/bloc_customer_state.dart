part of 'bloc_customer.dart';

abstract class BlocCustomerState {
  const BlocCustomerState();
}

class BlocCustomerInitial extends BlocCustomerState {
  const BlocCustomerInitial();
}

class BlocCustomerLoading extends BlocCustomerState {
  const BlocCustomerLoading();
}

class BlocCustomerError extends BlocCustomerState {
  final String message;
  BlocCustomerError({required this.message});
}

class BlocCustomerLoadListSuccess extends BlocCustomerState {
  final List<Customer> listCustomer;
  final Map<String, dynamic> statistic;
  final int page;
  final int maxPage;
  const BlocCustomerLoadListSuccess({required this.listCustomer, required this.statistic, this.page = 1, this.maxPage = 1});
}

class BlocCustomerLoadCoinSuccess extends BlocCustomerState {
  final int coin;
  final int rose;
  const BlocCustomerLoadCoinSuccess({required this.coin, required this.rose});
}

class BlocCustomerLoadDetailsSuccess extends BlocCustomerState {
  final Map<String, dynamic> customerData;
  final int id;
  const BlocCustomerLoadDetailsSuccess({required this.customerData, required this.id});
}

class BlocCustomerCreateSuccess extends BlocCustomerState {
  final String message;

  const BlocCustomerCreateSuccess({required this.message});
}

class BlocCustomerUpdateSuccess extends BlocCustomerState {
  final String message;

  const BlocCustomerUpdateSuccess({required this.message});
}

class BlocCustomerUpdateDetailSuccess extends BlocCustomerState {
  final String message;
  final Map<String, dynamic> customerData;
  const BlocCustomerUpdateDetailSuccess({required this.message, required this.customerData});
}

class BlocCustomerDeleteSuccess extends BlocCustomerState {
  final String message;

  const BlocCustomerDeleteSuccess({required this.message});
}
