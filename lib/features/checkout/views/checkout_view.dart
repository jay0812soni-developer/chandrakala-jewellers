import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/logger_service.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../cart/bloc/cart_state.dart';
import '../bloc/checkout_bloc.dart';
import '../bloc/checkout_event.dart';
import '../bloc/checkout_state.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _emailController = TextEditingController();

  String _paymentMethod = 'whatsapp';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitOrder(List<int> itemIds) {
    if (!_formKey.currentState!.validate()) return;

    AppLogger.info('Initiating order reservation for ${itemIds.length} items');
    context.read<CheckoutBloc>().add(
          PlaceOrderEvent(
            itemIds: itemIds,
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            address: _addressController.text.trim(),
            pincode: _pincodeController.text.trim(),
            email: _emailController.text.trim(),
            paymentMethod: _paymentMethod,
          ),
        );
  }

  void _sendWhatsAppOrderMessage(Map<String, dynamic> order) async {
    final orderNo = order['order_no'] ?? '';
    final grandTotal = order['grand_total'] ?? 0;
    final message = Uri.encodeComponent(
      'Namaste ChandraKala Jewellers,\n'
      'I have placed order *$orderNo* on your app.\n'
      'Name: ${_nameController.text.trim()}\n'
      'Phone: ${_phoneController.text.trim()}\n'
      'Address: ${_addressController.text.trim()}, ${_pincodeController.text.trim()}\n'
      'Total Amount: ₹$grandTotal\n\n'
      'Please confirm my gold reservation.',
    );

    final url = Uri.parse('https://wa.me/${AppConstants.shopWhatsAppNumber}?text=$message');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CHECKOUT & RESERVATION'),
        ),
        // BlocListener listens strictly to side-effects (navigation, dialogs, toasts)
        body: BlocListener<CheckoutBloc, CheckoutState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == CheckoutStatus.failure) {
              AppLogger.error('Order reservation error: ${state.errorMessage}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Reservation failed'),
                  backgroundColor: AppColors.error,
                ),
              );
            } else if (state.status == CheckoutStatus.reserved) {
              AppLogger.info('Item locked! Order ID: ${state.orderData?['order_no']}');

              // Clear cart upon successful reservation
              context.read<CartBloc>().add(const ClearCartEvent());

              // Show Success Modal
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogCtx) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: const Row(
                    children: [
                      Icon(Icons.verified, color: AppColors.success, size: 28),
                      SizedBox(width: 10),
                      Text('Item Reserved!', style: TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order No: ${state.orderData?['order_no']}',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkGold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your piece is locked for 24 hours. No other customer can purchase it while reserved.',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  actions: [
                    if (_paymentMethod == 'whatsapp')
                      ElevatedButton.icon(
                        icon: const Icon(Icons.chat, color: Colors.white, size: 18),
                        label: const Text('Confirm on WhatsApp'),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366)),
                        onPressed: () {
                          Navigator.pop(dialogCtx);
                          _sendWhatsAppOrderMessage(state.orderData ?? {});
                          context.go('/gallery');
                        },
                      ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogCtx);
                        context.go('/gallery');
                      },
                      child: const Text('Back to Store'),
                    ),
                  ],
                ),
              );
            }
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              if (cartState.items.isEmpty) {
                return const Center(child: Text('No items to checkout.'));
              }

              final itemIds = cartState.items.map((e) => e.item.id).toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Reservation Guarantee Notice
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.lightGold,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.lock_clock, color: AppColors.darkGold, size: 24),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Placing order reserves this unique jewellery piece for 24 hours under your name.',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text('Customer Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Full Name *', border: OutlineInputBorder()),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your full name' : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Mobile Number *',
                          prefixText: '+91 ',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().length < 10) return 'Enter 10-digit mobile number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'Delivery Address *', border: OutlineInputBorder()),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter delivery address' : null,
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _pincodeController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Pincode *', border: OutlineInputBorder()),
                              validator: (v) => (v == null || v.trim().length < 6) ? 'Enter 6-digit pincode' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(labelText: 'Email (Optional)', border: OutlineInputBorder()),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      const Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),

                      RadioListTile<String>(
                        title: const Text('WhatsApp Confirmation / Store Pickup'),
                        subtitle: const Text('Reserve piece now, pay on delivery or at Khedbrahma store'),
                        value: 'whatsapp',
                        groupValue: _paymentMethod,
                        activeColor: AppColors.primaryGold,
                        onChanged: (val) => setState(() => _paymentMethod = val!),
                      ),
                      RadioListTile<String>(
                        title: const Text('Online Payment / UPI / Netbanking'),
                        subtitle: const Text('Secure payment processed via Razorpay'),
                        value: 'razorpay',
                        groupValue: _paymentMethod,
                        activeColor: AppColors.primaryGold,
                        onChanged: (val) => setState(() => _paymentMethod = val!),
                      ),

                      const Divider(height: 32),

                      // Order Total Summary
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total to Pay (inc. GST):', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          Text(
                            CurrencyFormatter.format(cartState.grandTotal),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primaryGold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      BlocBuilder<CheckoutBloc, CheckoutState>(
                        builder: (context, checkoutState) {
                          final isLoading = checkoutState.status == CheckoutStatus.loading;

                          return SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : () => _submitOrder(itemIds),
                              child: isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('CONFIRM RESERVATION & ORDER'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
