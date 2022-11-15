part of 'bloc_customer.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Customer> get props => [];
}

class BlocCustomerLoadListEvent extends CustomerEvent {
  final User userInfo;
  final int page;
  final String? keySearch;
  const BlocCustomerLoadListEvent({
    required this.userInfo,
    this.page = 1,
    this.keySearch,
  });
}

class BlocCustomerLoadCoinEvent extends CustomerEvent {
  final User userInfo;
  const BlocCustomerLoadCoinEvent({required this.userInfo});
}

class BlocCustomerDetailEvent extends CustomerEvent {
  final User userInfo;
  final Customer customerInfo;
  final int id;
  const BlocCustomerDetailEvent({
    required this.userInfo,
    required this.id,
    required this.customerInfo,
  });
}

class BlocCustomerCreateEvent extends CustomerEvent {
  final User userInfo;
  final String name;
  final String phone;
  final String? note;
  const BlocCustomerCreateEvent({
    required this.userInfo,
    required this.name,
    required this.phone,
    this.note,
  });
}

class BlocCustomerUpdateEvent extends CustomerEvent {
  final User userInfo;
  final int id;
  final String? name;
  final String? phone;
  final String? note;
  const BlocCustomerUpdateEvent({
    required this.userInfo,
    required this.id,
    this.name,
    this.phone,
    this.note,
  });
}

class BlocCustomerDeleteEvent extends CustomerEvent {
  final User userInfo;
  final int id;
  const BlocCustomerDeleteEvent({
    required this.userInfo,
    required this.id,
  });
}
