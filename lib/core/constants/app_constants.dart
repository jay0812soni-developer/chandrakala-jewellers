class AppConstants {
  static const String appName = 'ChandraKala Jewellers';
  static const String appTagline = 'Gold & Silver Craftsmanship in Khedbrahma';
  static const String shopWhatsAppNumber = '919427080359';
  static const String shopPhoneDisplay = '+91 9427080359';
  static const String shopEmail = 'chandrakalajewellers849@gmail.com';
  static const String googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=Chandrakala+jewellers,+22JW%2BHG9,+Khedbrahma,+Gujarat+383255&destination_place_id=0x395d0b1a27d5a3df:0x216db437426f9e6a';

  // Base API URL (can be overridden with --dart-define=API_URL=...)
  static const String apiBaseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://cj-backend-kappa.vercel.app/api',
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
