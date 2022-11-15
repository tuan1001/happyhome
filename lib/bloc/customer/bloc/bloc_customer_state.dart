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
  final int page;

  const BlocCustomerLoadListSuccess({required this.listCustomer, this.page = 1});
}

class BlocCustomerLoadCoinSuccess extends BlocCustomerState {
  final int coin;
  const BlocCustomerLoadCoinSuccess({required this.coin});
}

class BlocCustomerLoadDetailsSuccess extends BlocCustomerState {
  final Customer customer;
  final Map<String, dynamic> customerData;
  const BlocCustomerLoadDetailsSuccess({required this.customerData, required this.customer});
}

class BlocCustomerCreateSuccess extends BlocCustomerState {
  final String message;

  const BlocCustomerCreateSuccess({required this.message});
}

class BlocCustomerUpdateSuccess extends BlocCustomerState {
  final String message;

  const BlocCustomerUpdateSuccess({required this.message});
}

class BlocCustomerDeleteSuccess extends BlocCustomerState {
  final String message;

  const BlocCustomerDeleteSuccess({required this.message});
}
