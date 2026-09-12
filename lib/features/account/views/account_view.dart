import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scaffold.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  bool _isLoggedIn = false;
  String _customerName = '';
  String _customerPhone = '';

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCustomerProfile();
  }

  Future<void> _loadCustomerProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('cj_customer_name') ?? '';
    final phone = prefs.getString('cj_customer_phone') ?? '';
    final address = prefs.getString('cj_customer_address') ?? '';

    setState(() {
      _customerName = name;
      _customerPhone = phone;
      _isLoggedIn = name.isNotEmpty && phone.isNotEmpty;
      _nameController.text = name;
      _phoneController.text = phone;
      _addressController.text = address;
    });
  }

  Future<void> _saveCustomerProfile() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name and phone number')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cj_customer_name', name);
    await prefs.setString('cj_customer_phone', phone);
    await prefs.setString('cj_customer_address', address);

    setState(() {
      _customerName = name;
      _customerPhone = phone;
      _isLoggedIn = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully! Welcome to ChandraKala Jewellers.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cj_customer_name');
    await prefs.remove('cj_customer_phone');
    await prefs.remove('cj_customer_address');

    setState(() {
      _isLoggedIn = false;
      _customerName = '';
      _customerPhone = '';
      _nameController.clear();
      _phoneController.clear();
      _addressController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out from customer account.')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      currentRoute: '/account',
      title: 'Customer Account',
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E212B) : AppColors.champagne,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryGold, width: 1.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.person_outline_rounded, color: AppColors.darkGold, size: 28),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isLoggedIn ? _customerName : 'Customer Account',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          _isLoggedIn ? '+91 $_customerPhone · Verified Customer' : 'Sign in for fast checkout & orders',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: isDark ? const Color(0xFFB5BAC6) : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161A22) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? const Color(0xFF2E3544) : AppColors.champagne,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(isDark ? 80 : 10),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isLoggedIn ? 'Your Delivery Profile' : 'Quick Sign In / Register',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFFF0D78C) : AppColors.darkGold,
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'e.g. Ramesh Patel',
                          prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.darkGold),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          hintText: '10-digit mobile number',
                          prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.darkGold),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Delivery Address / Landmark',
                          hintText: 'e.g. Civil Road, Khedbrahma',
                          prefixIcon: const Icon(Icons.home_outlined, color: AppColors.darkGold),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveCustomerProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGold,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                _isLoggedIn ? 'Update Profile' : 'Save & Continue',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          if (_isLoggedIn) ...[
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: _signOut,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                                side: const BorderSide(color: Colors.redAccent),
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Sign Out'),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Order & Reservation History',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Guest checkout works seamlessly. Past jewellery reservations confirmed via WhatsApp or online are linked to your phone number.',
                  style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1F2430) : AppColors.champagne.withAlpha(80),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryGold.withAlpha(40)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt_long_outlined, color: AppColors.darkGold, size: 28),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          _isLoggedIn
                              ? 'Active Account: $_customerPhone. When you place orders, live updates will appear here.'
                              : 'Sign in with your phone number to track your reservation updates.',
                          style: GoogleFonts.poppins(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
