import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/customer_auth_service.dart';
import '../../../core/widgets/app_scaffold.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final _auth = CustomerAuthService();
  final _loginPhone = TextEditingController();
  final _loginPassword = TextEditingController();
  final _regName = TextEditingController();
  final _regPhone = TextEditingController();
  final _regEmail = TextEditingController();
  final _regPassword = TextEditingController();

  CustomerSession? _session;
  List<Map<String, dynamic>> _history = [];
  String _flash = '';
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final session = await _auth.current();
    if (!mounted) return;
    setState(() => _session = session);
    if (session != null) {
      await _loadHistory();
    }
  }

  Future<void> _loadHistory() async {
    try {
      final rows = await _auth.orderHistory();
      if (!mounted) return;
      setState(() => _history = rows);
    } catch (_) {
      if (!mounted) return;
      setState(() => _history = []);
    }
  }

  String _apiMessage(Object error, String fallback) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
    }
    return fallback;
  }

  Future<void> _signIn() async {
    setState(() {
      _busy = true;
      _flash = '';
    });
    try {
      final session = await _auth.login(
        phone: _loginPhone.text.trim(),
        password: _loginPassword.text,
      );
      if (!mounted) return;
      setState(() {
        _session = session;
        _flash = 'Signed in.';
      });
      await _loadHistory();
    } catch (e) {
      if (!mounted) return;
      setState(() => _flash = _apiMessage(e, 'Mobile number or password is incorrect.'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _register() async {
    setState(() {
      _busy = true;
      _flash = '';
    });
    try {
      final session = await _auth.register(
        name: _regName.text.trim(),
        phone: _regPhone.text.trim(),
        password: _regPassword.text,
        email: _regEmail.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _session = session;
        _flash = 'Account created.';
      });
      await _loadHistory();
    } catch (e) {
      if (!mounted) return;
      setState(() => _flash = _apiMessage(e, 'Could not create account.'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signOut() async {
    await _auth.logout();
    if (!mounted) return;
    setState(() {
      _session = null;
      _history = [];
      _flash = '';
      _loginPassword.clear();
      _regPassword.clear();
    });
  }

  @override
  void dispose() {
    _loginPhone.dispose();
    _loginPassword.dispose();
    _regName.dispose();
    _regPhone.dispose();
    _regEmail.dispose();
    _regPassword.dispose();
    super.dispose();
  }

  InputDecoration _field(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
    );
  }

  Widget _goldButton(String label, VoidCallback? onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _busy ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _formCard({required String title, required List<Widget> children}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return AppScaffold(
      currentRoute: '/account',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 80),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My account',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                if (_flash.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(_flash, style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFFB45309))),
                ],
                const SizedBox(height: 8),
                if (_session != null) ...[
                  Text.rich(
                    TextSpan(
                      text: 'Hello, ',
                      style: GoogleFonts.poppins(fontSize: 15, color: secondary),
                      children: [
                        TextSpan(
                          text: _session!.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: _busy ? null : _signOut,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.cardBorder),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Sign out'),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Order history',
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  if (_history.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'No orders on this account yet. Guest checkout still works — orders appear here when placed while signed in, or with the same mobile number.',
                        style: GoogleFonts.poppins(fontSize: 14, color: secondary),
                      ),
                    )
                  else
                    ..._history.map(_orderCard),
                ] else ...[
                  Text(
                    'Optional — you can always checkout as a guest. Sign in only if you want order history on this device.',
                    style: GoogleFonts.poppins(fontSize: 14, color: secondary, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 720;
                      final signIn = _formCard(
                        title: 'Sign in',
                        children: [
                          TextField(
                            controller: _loginPhone,
                            keyboardType: TextInputType.phone,
                            decoration: _field('Mobile'),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _loginPassword,
                            obscureText: true,
                            decoration: _field('Password'),
                          ),
                          const SizedBox(height: 10),
                          _goldButton('Sign in', _signIn),
                        ],
                      );
                      final register = _formCard(
                        title: 'Create account',
                        children: [
                          TextField(controller: _regName, decoration: _field('Name')),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _regPhone,
                            keyboardType: TextInputType.phone,
                            decoration: _field('Mobile'),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _regEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _field('Email (optional)'),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _regPassword,
                            obscureText: true,
                            decoration: _field('Password'),
                          ),
                          const SizedBox(height: 10),
                          _goldButton('Create account', _register),
                        ],
                      );
                      if (!wide) {
                        return Column(
                          children: [
                            signIn,
                            const SizedBox(height: 24),
                            register,
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: signIn),
                          const SizedBox(width: 24),
                          Expanded(child: register),
                        ],
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _orderCard(Map<String, dynamic> pack) {
    final order = Map<String, dynamic>.from(pack['order'] as Map? ?? {});
    final items = (pack['items'] as List? ?? []).map((e) => Map<String, dynamic>.from(e as Map)).toList();
    final orderNo = order['order_no']?.toString() ?? '';
    final status = order['status']?.toString() ?? '';
    final payment = order['payment_status']?.toString() ?? '';
    final created = order['created_at']?.toString() ?? '';
    final total = num.tryParse(order['grand_total']?.toString() ?? order['subtotal']?.toString() ?? '0') ?? 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$orderNo · $status · $payment',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            '$created · ₹${total.round()}',
            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (line) => Text(
              '${line['product_name'] ?? ''} · ₹${num.tryParse(line['unit_price']?.toString() ?? '0')?.round() ?? 0}',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
