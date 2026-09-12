import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scaffold.dart';

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendWhatsAppInquiry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final message = _messageController.text.trim();

    final text = '*Inquiry for ChandraKala Jewellers*\n\n'
        '*Name:* $name\n'
        '*Phone:* $phone\n'
        '*Message:* $message\n\n'
        '_Sent from online store_';

    final uri = Uri.parse('https://wa.me/919427080359?text=${Uri.encodeComponent(text)}');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening WhatsApp with your inquiry...')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp. Please call +91 9427080359.')),
        );
      }
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: '/contact',
      title: 'Contact Us',
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.lightGold, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'Contact ChandraKala Jewellers',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Visit our gold & silver showroom, call us, or send a quick inquiry on WhatsApp.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 860),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Contact Info Cards Layout
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 650;
                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildInfoPanel()),
                              const SizedBox(width: 24),
                              Expanded(child: _buildInquiryForm()),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              _buildInfoPanel(),
                              const SizedBox(height: 24),
                              _buildInquiryForm(),
                            ],
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 36),

                    // Google Maps Location Section
                    _buildMapsSection(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPanel() {
    return Column(
      children: [
        _buildContactCard(
          icon: Icons.location_on_rounded,
          title: 'Store Address',
          content: 'ChandraKala Jewellers\n22JW+HG9, Opp. Bhoomi Complex, Civil Road\nKhedbrahma-383255, Gujarat',
          actionText: 'Open in Google Maps',
          onTapAction: () async {
            final uri = Uri.parse('https://maps.app.goo.gl/3QW5r9qC2C6pE95b8');
            if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
          },
        ),
        const SizedBox(height: 14),
        _buildContactCard(
          icon: Icons.phone_in_talk_rounded,
          title: 'Direct Phone',
          content: '+91 9427080359\nMon - Sat: 10:00 AM - 8:00 PM',
          actionText: 'Call Now',
          onTapAction: () async {
            final uri = Uri.parse('tel:+919427080359');
            if (await canLaunchUrl(uri)) launchUrl(uri);
          },
        ),
        const SizedBox(height: 14),
        _buildContactCard(
          icon: Icons.mail_outline_rounded,
          title: 'Showroom Email',
          content: 'chandrakalajewellers849@gmail.com',
          actionText: 'Send Email',
          onTapAction: () async {
            final uri = Uri.parse('mailto:chandrakalajewellers849@gmail.com');
            if (await canLaunchUrl(uri)) launchUrl(uri);
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              final uri = Uri.parse('https://wa.me/919427080359');
              if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
            },
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
            label: const Text('Chat on WhatsApp'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse('https://www.instagram.com/chandra.kalajewellers');
                  if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                icon: const Icon(Icons.camera_alt_outlined, size: 16, color: AppColors.darkGold),
                label: const Text('Instagram', style: TextStyle(color: AppColors.darkGold, fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryGold),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.go('/follow-us'),
                icon: const Icon(Icons.qr_code_2_rounded, size: 16, color: AppColors.darkGold),
                label: const Text('Reviews & QR', style: TextStyle(color: AppColors.darkGold, fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryGold),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String content,
    required String actionText,
    required VoidCallback onTapAction,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.champagne,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.darkGold, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: onTapAction,
            child: Text(
              actionText,
              style: const TextStyle(
                color: AppColors.darkGold,
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInquiryForm() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Send an Inquiry',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Fill in your details and we will open WhatsApp with your message ready to send.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                hintText: 'Full Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.person_outline, size: 20),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: '10-digit mobile number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.phone_outlined, size: 20),
              ),
              validator: (v) => (v == null || v.trim().length < 10) ? 'Enter valid 10-digit phone number' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Tell us what jewellery you are looking for...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                alignLabelWithHint: true,
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please describe what you are looking for' : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _sendWhatsAppInquiry,
                icon: const Icon(Icons.send_rounded, size: 18),
                label: Text(_isSubmitting ? 'Preparing...' : 'Send via WhatsApp'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.champagne,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGold.withAlpha(100)),
      ),
      child: Column(
        children: [
          const Icon(Icons.map_rounded, color: AppColors.darkGold, size: 36),
          const SizedBox(height: 10),
          const Text(
            'Find Us on Google Maps',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'ChandraKala Jewellers — 22JW+HG9, Khedbrahma, Gujarat 383255\nCoordinates: 24.0314016, 73.0463503',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 14,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(
                    'https://www.google.com/maps/dir/?api=1&destination=Chandrakala+jewellers,+22JW%2BHG9,+Khedbrahma,+Gujarat+383255&destination_place_id=0x395d0b1a27d5a3df:0x216db437426f9e6a',
                  );
                  if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                icon: const Icon(Icons.directions_rounded, size: 18),
                label: const Text('Get Directions'),
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse('https://maps.app.goo.gl/3QW5r9qC2C6pE95b8');
                  if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                icon: const Icon(Icons.open_in_new_rounded, size: 18, color: AppColors.darkGold),
                label: const Text('Open in Google Maps', style: TextStyle(color: AppColors.darkGold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryGold),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
