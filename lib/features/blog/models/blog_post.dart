import 'package:equatable/equatable.dart';

class BlogSection extends Equatable {
  final String heading;
  final String text;

  const BlogSection({
    required this.heading,
    required this.text,
  });

  @override
  List<Object?> get props => [heading, text];
}

class BlogPost extends Equatable {
  final String slug;
  final String tag;
  final String title;
  final String excerpt;
  final String fallback;
  final String lead;
  final List<BlogSection> body;

  const BlogPost({
    required this.slug,
    required this.tag,
    required this.title,
    required this.excerpt,
    required this.fallback,
    required this.lead,
    required this.body,
  });

  @override
  List<Object?> get props => [slug, tag, title, excerpt, fallback, lead, body];
}

const List<BlogPost> defaultBlogPosts = [
  BlogPost(
    slug: 'jewellery-care-tips',
    tag: 'Care Tips',
    title: 'Jewellery Care Tips',
    excerpt: 'Learn how to keep your jewellery sparkling with our expert care tips for gold and silver pieces.',
    fallback: 'Jewellery Care',
    lead: 'Jewellery is not just an accessory; it is a reflection of your personality and style. To keep your jewellery looking its best, follow these essential care tips from ChandraKala Jewellers.',
    body: [
      BlogSection(heading: 'Store Properly', text: 'Always store your jewellery in a dry place, preferably in a soft cloth or a jewellery box to prevent scratches.'),
      BlogSection(heading: 'Avoid Chemicals', text: 'Keep your jewellery away from harsh chemicals, perfumes, and lotions that can tarnish or damage the metal and stones.'),
      BlogSection(heading: 'Regular Cleaning', text: 'Clean your jewellery regularly with a soft cloth. For deeper cleaning, use a mild soap solution and a soft brush.'),
      BlogSection(heading: 'Avoid Water', text: 'Remove your jewellery before swimming or showering to avoid exposure to chlorine or saltwater.'),
      BlogSection(heading: 'Professional Maintenance', text: 'Consider taking your jewellery to a professional jeweller for maintenance and repairs at least once a year.'),
    ],
  ),
  BlogPost(
    slug: 'choosing-the-right-gold',
    tag: 'Buying Guide',
    title: 'Choosing the Right Gold',
    excerpt: 'Understand hallmarking, purity, and making charges so you shop with confidence.',
    fallback: 'Gold Guide',
    lead: 'Buying gold should feel clear and confident. Here is a simple guide to purity, hallmarking, and what affects the final price.',
    body: [
      BlogSection(heading: 'Know the Purity', text: '916 gold (22K) is a popular choice for traditional jewellery — it balances purity with durability for everyday and occasion wear.'),
      BlogSection(heading: 'Look for Hallmarking', text: 'Hallmarked jewellery confirms purity standards. Always ask about hallmark details when you purchase.'),
      BlogSection(heading: 'Understand Making Charges', text: 'The final price includes metal value plus making charges. We are transparent about how rates are calculated in our store.'),
      BlogSection(heading: 'Choose for Lifestyle', text: 'Daily wear pieces benefit from sturdy designs; statement pieces can be more ornate for celebrations.'),
      BlogSection(heading: 'Ask Us', text: 'Our team in Khedbrahma is happy to help you compare options and find the right weight and design for your budget.'),
    ],
  ),
  BlogPost(
    slug: 'jewellery-for-every-occasion',
    tag: 'Style',
    title: 'Jewellery for Every Occasion',
    excerpt: 'From daily wear to wedding celebrations — find pieces that match every moment.',
    fallback: 'Occasions',
    lead: 'The right piece elevates every moment — from a quiet day at work to a wedding celebration. Here is how to match jewellery to the occasion.',
    body: [
      BlogSection(heading: 'Daily Elegance', text: 'Lightweight gold or silver designs keep you polished without weighing you down through a busy day.'),
      BlogSection(heading: 'Festive Wear', text: 'Layered necklaces, statement earrings, and coordinated sets bring traditional sparkle to festivals.'),
      BlogSection(heading: 'Weddings & Rituals', text: 'Heirloom-inspired sets and bridal favourites make lasting memories — visit our catalogue for design inspiration.'),
      BlogSection(heading: 'Gifting', text: 'A thoughtfully chosen pendant or bangle is a timeless gift. Tell us the occasion and we will suggest options.'),
      BlogSection(heading: 'Personal Touch', text: 'Custom design references from our catalogue can be crafted to suit your taste — ask us in store or on WhatsApp.'),
    ],
  ),
  BlogPost(
    slug: 'jewellers-in-khedbrahma-guide',
    tag: 'Local Guide',
    title: 'Finding Jewellers in Khedbrahma',
    excerpt: 'How to choose a trusted jewellery shop in Khedbrahma and Sabarkantha — rates, hallmark, and why locals visit ChandraKala Jewellers.',
    fallback: 'Khedbrahma',
    lead: 'Searching for jewellers, jewellery shops, or "jewellers near me" in Khedbrahma? Here is how locals choose a trusted gold and silver store in Sabarkantha — and how ChandraKala Jewellers on Civil Road helps.',
    body: [
      BlogSection(heading: 'Check the location', text: 'A clear Google Maps listing and Civil Road address (Opp. Bhoomi Complex) make visits easy for families across Khedbrahma.'),
      BlogSection(heading: 'Ask about rates', text: 'Transparent 916 gold and silver rates — published and explained — build trust before you buy.'),
      BlogSection(heading: 'See real stock', text: 'Browse our online gallery for gold, silver, and 925 pieces, then confirm on WhatsApp or in store.'),
      BlogSection(heading: 'Custom designs', text: 'Use our design catalogue when you want something crafted for weddings or personal gifts.'),
      BlogSection(heading: 'Same brand, many spellings', text: 'ChandraKala and Chandrakala Jewellers are the same family store — search either name on Maps to find us.'),
    ],
  ),
];
