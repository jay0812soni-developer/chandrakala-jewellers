class AppConstants {
  static const String appName = 'ChandraKala Jewellers';
  static const String appTagline = 'Gold & Silver Craftsmanship in Khedbrahma';
  static const String shopWhatsAppNumber = '919427080359';
  static const String shopPhoneDisplay = '+91 9427080359';
  static const String shopEmail = 'chandrakalajewellers849@gmail.com';

  // Base API URL (can be overridden with --dart-define=API_URL=...)
  static const String apiBaseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://cj-backend-vercel.vercel.app/api',
  );

  // Asset CDN base URL for jewellery pictures
  static const String cdnBaseUrl = String.fromEnvironment(
    'CDN_BASE_URL',
    defaultValue: 'https://chandrakalajewellers.in/uploads/',
  );

  static const String catalogueCdnUrl = String.fromEnvironment(
    'CATALOGUE_CDN_URL',
    defaultValue: 'https://chandrakalajewellers.in/catalogue/',
  );
}
