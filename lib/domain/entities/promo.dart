import 'package:dago_valley_explore/domain/entities/promo_translation.dart';

class Promo {
  final int id;
  final String housingId;
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final String tag1;
  final String tag2;
  final PromoTranslation en;

  Promo({
    required this.id,
    required this.housingId,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.tag1,
    required this.tag2,
    required this.en,
  });

  factory Promo.fromJson(Map<String, dynamic> json) => Promo(
    id: json["id"],
    housingId: json["housing_id"],
    title: json["title"],
    subtitle: json["subtitle"],
    description: json["description"],
    imageUrl: json["imageUrl"],
    tag1: json["tag1"],
    tag2: json["tag2"],
    en: PromoTranslation.fromJson(json["en"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "housing_id": housingId,
    "title": title,
    "subtitle": subtitle,
    "description": description,
    "imageUrl": imageUrl,
    "tag1": tag1,
    "tag2": tag2,
    "en": en.toJson(),
  };
}

final List<Promo> dummyPromos = [
  Promo(
    id: 1,
    housingId: '',
    title: 'Miliki Kavling Impian di Lokasi Paling Dicari di Bandung!',
    subtitle: 'Hemat Hingga 50%',
    description:
        '''Tersedia 2 unit terakhir di Perumahan Eksklusif Dago Valley, Dago, Bandung – sebuah lokasi yang tak hanya menawarkan lingkungan alam yang indah, tetapi juga nilai investasi yang terus meningkat. Ini adalah kesempatan langka untuk membangun rumah impian Anda di lingkungan yang nyaman dan prestisius. 
Harga Promo Istimewa Hanya Sampai Akhir 30 Mei 2024!
Jangan Tunda Lagi! 
Hubungi kami sekarang untuk informasi lebih lanjut.''',
    imageUrl: 'assets/promo/promo1.jpg',
    tag1: 'Open House',
    tag2: 'Hemat',
    en: PromoTranslation(
      title:
          'Own Your Dream Plot in the Most Sought-After Location in Bandung!',
      subtitle: 'Save Up to 50%',
      description:
          '''Only 2 units left in the Exclusive Dago Valley Housing Complex, Dago, Bandung – a location that not only offers a beautiful natural environment but also a continuously increasing investment value. This is a rare opportunity to build your dream home in a comfortable and prestigious environment.
Special Promo Price Only Until May 30, 2024!
Don't Wait Any Longer!
Contact us now for more information.''',
      tag1: '',
      tag2: '',
    ),
  ),
  Promo(
    title: 'Temukan kenyamanan dan kemewahan hidup di Dago Valley, Bandung.',
    subtitle:
        'kawasan hunian eksklusif dengan suasana hijau dan udara sejuk khas Dago',
    description:
        '''Temukan kenyamanan dan kemewahan hidup di Dago Valley, Bandung — kawasan hunian eksklusif dengan suasana hijau dan udara sejuk khas Dago.
Kini, setiap pembelian unit rumah di Dago Valley semakin istimewa!
Nikmati Bonus Kitchen Set senilai 50 juta rupiah untuk melengkapi rumah impian Anda.
Hunian modern dengan desain elegan, lokasi strategis, dan lingkungan yang asri — sempurna untuk keluarga yang mendambakan kualitas hidup lebih baik.
🎁 Promo terbatas!
Segera amankan unit pilihan Anda sebelum promo berakhir.''',
    imageUrl: 'assets/promo/promo2.jpg',
    tag1: 'Akhir Tahun',
    tag2: 'Hemat',
    en: PromoTranslation(
      title:
          'Discover the Comfort and Luxury of Living in Dago Valley, Bandung.',
      subtitle:
          'An exclusive residential area with a green atmosphere and cool Dago air.',
      description:
          '''Discover the comfort and luxury of living in Dago Valley, Bandung — an exclusive residential area with a green atmosphere and cool Dago air.
Now, every purchase of a house unit in Dago Valley becomes even more special!
Enjoy a Kitchen Set Bonus worth 50 million rupiah to complete your dream home.
Modern residences with elegant designs, strategic locations, and lush environments — perfect for families seeking a better quality of life.
🎁 Limited promo!
Secure your chosen unit before the promo ends.''',
      tag1: '',
      tag2: '',
    ),
    id: 1,
    housingId: '',
  ),
  Promo(
    title: 'Rasakan kesejukan dan ketenangan hidup di Dago Valley, Bandung,',
    subtitle: 'hanya beberapa menit dari pusat kota.',
    description:
        '''Persembahan terbaru kami, Harmony Type 76/108, menawarkan desain rumah modern dengan kenyamanan maksimal bagi keluarga Anda.
Kini tersedia dengan harga spesial mulai dari 1,9 M (all in) — termasuk Free BPHTB dan PPN, serta potongan harga hingga ratusan juta rupiah.
Inilah kesempatan terbaik untuk memiliki hunian premium dengan lingkungan alami yang menenangkan.
Hidup lebih sehat, lebih tenang, dan lebih dekat dengan alam — hanya di Dago Valley.''',
    imageUrl: 'assets/promo/promo3.jpg',
    tag1: 'Akhir Tahun',
    tag2: 'Hemat',
    en: PromoTranslation(
      title:
          'Experience the Coolness and Tranquility of Life in Dago Valley, Bandung',
      subtitle: 'Just a few minutes from the city center.',
      description:
          '''Our latest offering, Harmony Type 76/108, features modern home designs with maximum comfort for your family.
Now available at a special price starting from 1.9 billion (all in) — including Free BPHTB and VAT, as well as discounts of up to hundreds of millions of rupiah.
This is the best opportunity to own a premium residence in a calming natural environment.
Live healthier, calmer, and closer to nature — only in Dago Valley.''',
      tag1: '',
      tag2: '',
    ),
    id: 1,
    housingId: '',
  ),
];

final List<Promo> dummyEvents = [
  Promo(
    title: 'Miliki Kavling Impian di Lokasi Paling Dicari di Bandung!',
    subtitle: 'Hemat Hingga 50%',
    description:
        '''Tersedia 2 unit terakhir di Perumahan Eksklusif Dago Valley, Dago, Bandung – sebuah lokasi yang tak hanya menawarkan lingkungan alam yang indah, tetapi juga nilai investasi yang terus meningkat. Ini adalah kesempatan langka untuk membangun rumah impian Anda di lingkungan yang nyaman dan prestisius. 
Harga Promo Istimewa Hanya Sampai Akhir 30 Mei 2024!
Jangan Tunda Lagi! 
Hubungi kami sekarang untuk informasi lebih lanjut.''',
    imageUrl: 'assets/event/openhouse1.jpg',
    tag1: 'Open House',
    tag2: 'Hemat',
    en: PromoTranslation(
      title:
          'Own Your Dream Plot in the Most Sought-After Location in Bandung!',
      subtitle: 'Save Up to 50%',
      description:
          '''Last 2 units available in the Exclusive Dago Valley Housing Complex, Dago, Bandung – a location that not only offers a beautiful natural environment but also a continuously increasing investment value. This is a rare opportunity to build your dream home in a comfortable and prestigious environment.
Special Promo Price Only Until May 30, 2024!
Don't Wait Any Longer!
Contact us now for more information.''',
      tag1: '',
      tag2: '',
    ),
    id: 1,
    housingId: '',
  ),
  Promo(
    title: 'Temukan kenyamanan dan kemewahan hidup di Dago Valley, Bandung.',
    subtitle:
        'kawasan hunian eksklusif dengan suasana hijau dan udara sejuk khas Dago',
    description:
        '''Temukan kenyamanan dan kemewahan hidup di Dago Valley, Bandung — kawasan hunian eksklusif dengan suasana hijau dan udara sejuk khas Dago.
Kini, setiap pembelian unit rumah di Dago Valley semakin istimewa!
Nikmati Bonus Kitchen Set senilai 50 juta rupiah untuk melengkapi rumah impian Anda.
Hunian modern dengan desain elegan, lokasi strategis, dan lingkungan yang asri — sempurna untuk keluarga yang mendambakan kualitas hidup lebih baik.
🎁 Promo terbatas!
Segera amankan unit pilihan Anda sebelum promo berakhir.''',
    imageUrl: 'assets/event/openhouse2.jpg',
    tag1: 'Akhir Tahun',
    tag2: 'Hemat',
    en: PromoTranslation(
      title:
          'Discover the Comfort and Luxury of Living in Dago Valley, Bandung.',
      subtitle:
          'An exclusive residential area with a green atmosphere and cool Dago air.',
      description:
          '''Discover the comfort and luxury of living in Dago Valley, Bandung — an exclusive residential area with a green atmosphere and cool Dago air.
Now, every purchase of a house unit in Dago Valley becomes even more special!
Enjoy a Kitchen Set Bonus worth 50 million rupiah to complete your dream home.
Modern residences with elegant designs, strategic locations, and lush environments — perfect for families seeking a better quality of life.
🎁 Limited promo!
Secure your chosen unit before the promo ends.''',
      tag1: '',
      tag2: '',
    ),
    id: 1,
    housingId: '',
  ),
  Promo(
    title: 'Rasakan kesejukan dan ketenangan hidup di Dago Valley, Bandung,',
    subtitle: 'hanya beberapa menit dari pusat kota.',
    description:
        '''Persembahan terbaru kami, Harmony Type 76/108, menawarkan desain rumah modern dengan kenyamanan maksimal bagi keluarga Anda.
Kini tersedia dengan harga spesial mulai dari 1,9 M (all in) — termasuk Free BPHTB dan PPN, serta potongan harga hingga ratusan juta rupiah.
Inilah kesempatan terbaik untuk memiliki hunian premium dengan lingkungan alami yang menenangkan.
Hidup lebih sehat, lebih tenang, dan lebih dekat dengan alam — hanya di Dago Valley.''',
    imageUrl: 'assets/event/openhouse3.jpg',
    tag1: 'Akhir Tahun',
    tag2: 'Hemat',
    en: PromoTranslation(
      title:
          'Experience the Coolness and Tranquility of Life in Dago Valley, Bandung',
      subtitle: 'Just a few minutes from the city center.',
      description:
          '''Our latest offering, Harmony Type 76/108, features modern home designs with maximum comfort for your family.
Now available at a special price starting from 1.9 billion (all in) — including Free BPHTB and VAT, as well as discounts of up to hundreds of millions of rupiah.
This is the best opportunity to own a premium residence with a calming natural environment.
Live healthier, calmer, and closer to nature — only in Dago Valley.''',
      tag1: '',
      tag2: '',
    ),
    id: 1,
    housingId: '',
  ),
];
