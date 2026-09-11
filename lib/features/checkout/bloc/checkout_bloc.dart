import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_client.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final ApiClient _client = ApiClient();

  CheckoutBloc() : super(const CheckoutState()) {
    on<PlaceOrderEvent>(_onPlaceOrder);
  }

  Future<void> _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutState(status: CheckoutStatus.loading));
    try {
      final response = await _client.dio.post(
        '/orders/reserve',
        data: {
          'item_ids': event.itemIds,
          'customer_name': event.name,
          'customer_phone': event.phone,
          'customer_address': event.address,
          'customer_pincode': event.pincode,
          'customer_email': event.email,
          'payment_method': event.paymentMethod,
        },
      );

      if (response.statusCode == 201 && response.data['ok'] == true) {
        emit(CheckoutState(
          status: CheckoutStatus.reserved,
          orderData: response.data['data'],
        ));
      } else {
        emit(CheckoutState(
          status: CheckoutStatus.failure,
          errorMessage: response.data['message'] ?? 'Failed to reserve order',
        ));
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message']?.toString() ?? e.message ?? 'Order failed';
      emit(CheckoutState(
        status: CheckoutStatus.failure,
        errorMessage: errorMsg,
      ));
    } catch (e) {
      emit(CheckoutState(
        status: CheckoutStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
