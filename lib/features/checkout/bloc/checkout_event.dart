import 'package:equatable/equatable.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();
  @override
  List<Object?> get props => [];
}

class PlaceOrderEvent extends CheckoutEvent {
  final List<int> itemIds;
  final String name;
  final String phone;
  final String address;
  final String pincode;
  final String email;
  final String paymentMethod;

  const PlaceOrderEvent({
    required this.itemIds,
    required this.name,
    required this.phone,
    required this.address,
    required this.pincode,
    this.email = '',
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [itemIds, name, phone, address, pincode, email, paymentMethod];
}
