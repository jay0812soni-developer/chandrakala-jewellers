import 'package:equatable/equatable.dart';

enum CheckoutStatus { initial, loading, reserved, failure }

class CheckoutState extends Equatable {
  final CheckoutStatus status;
  final String? errorMessage;
  final Map<String, dynamic>? orderData;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.errorMessage,
    this.orderData,
  });

  @override
  List<Object?> get props => [status, errorMessage, orderData];
}
