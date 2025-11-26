import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    // Indonesian
    'id_ID': {
      //homepage
      'welcome_title': 'Rumah Mewah di Dago Valley Bandung',
      'welcome_desc':
          'Nikmati kenyamanan hidup dengan fasilitas lengkap dan lingkungan yang asri. Temukan rumah impian Anda di perumahan eksklusif ini.',
      'view_promo': "Lihat Promo",
      'site_plan': "Site Plan",
      'event': "Event",
      'documentation': "Dokumentasi",
      'house_type': "Tipe Rumah",
      'agreements_and_legality': "Legalitas & Perizinan",
      'check_availability': "Periksa ketersediaan",

      // siteplan page
      'siteplan_feature': 'Fitur Site Plan',
      'siteplan_feature_desc':
          'Fitur peta/siteplan sedang kami kembangkan. Segera hadir: tampilan interaktif, zoom, dan detail unit.',

      // virtual / product page
      'harmoni_desc': 'Hunian nyaman dengan desain modern tropis',
      'foresta_desc': 'Keseimbangan kemewahan dan keharmonisan alam',
      'tropica_desc': 'Keindahan alami dalam sentuhan modern',
      'view_details': 'Lihat Detail',
      'phase_one': 'Tahap 1',
      'phase_two': 'Tahap 2',

      // cash calculator page
      'mortgage_simulation': 'Simulasi KPR',
      'mortgage_simulation_desc':
          'Simulasi KPR membantu Anda menghitung perkiraan cicilan rumah berdasarkan harga, uang muka, dan lama cicilan. Dengan fitur ini, Anda bisa mengetahui estimasi angsuran bulanan agar lebih mudah merencanakan pembelian rumah impian.',
      'model_and_type': 'Model & Tipe',
      'choose_house_model': 'Pilih Model Rumah',
      'payment_method': 'Metode Pembayaran',
      'sharia_bank_mortgage': 'KPR Bank Syariah',
      'developer_mortgage': 'KPR Developer',
      'tenor': 'Tenor (tahun)',
      'years': 'Tahun',
      'no_down_payment': 'Tanpa DP',
      'choose_house_model_first': 'Pilih Model Rumah Dulu',
      'mortgage_margin': 'Margin KPR',
      'discount': 'Diskon',
      'summary': 'Ringkasan',
      'installment_table': 'Tabel Angsuran',

      'terms_n_conditions': 'Syarat & Ketentuan',
      'terms_one':
          'Harga tidak mengikat dan dapat berubah sewaktu-waktu tanpa pemberitahuan terlebih dahulu.',
      'terms_two':
          'Harga sudah termasuk biaya Notaris, Splitizing Sertipikat, AJB, BBN Sertipikat & IMB.',
      'terms_three':
          'Harga belum termasuk BPHTB & PPN (apabila terjadi perubahan tarif PPN maka selisih PPN ditanggung dan wajib dibayarkan oleh pembeli).',
      'terms_four':
          'Harga sudah termasuk biaya pemasangan daya listrik PLN dan suplai air bersih.',
      'terms_five':
          'Pembayaran Booking Fee sebesar Rp. 10.000.000,- (uang tidak dapat dikembalikan apabila konsumen melakukan pembatalan).',
      'terms_six':
          'Pembayaran pembelian unit cash keras dilakukan selambat-lambatnya 1 bulan setelah pembayaran Booking Fee.',
      'terms_seven':
          'Pembayaran DP untuk pembelian unit secara KPR dilakukan selambat-lambatnya 14 hari setelah pembayaran Booking Fee.',
      'terms_eight':
          'Persyaratan pembelian unit secara KPR: FC KTP/Paspor suami & istri, Surat Nikah, KK, NPWP, Rekening Koran 3 bulan terakhir, Slip Gaji, SK awal & akhir.',
      'terms_nine':
          'Apabila dilakukan perubahan/pemindahan lokasi kavling yang telah dipilih sebelumnya maka akan dikenakan biaya sebesar Rp. 3.000.000,-',
      'terms_ten':
          'Pembayaran melalui setoran tunai/transfer bank ditujukan ke rekening BSI (Bank Syariah Indonesia), nomor: 722-127-3607, a.n. PT. Cisitu Indah Lestari.',
      'terms_eleven':
          'Unit bangunan rumah indent (serah terima bangunan 12 bulan setelah pembayaran DP lunas atau pembayaran minimal 30% dari harga total diterima oleh Developer).',
      'terms_twelve':
          'Luas/spesifikasi tanah dan bangunan dapat berubah menyesuaikan ketentuan legalitas dari BPN, ketentuan perijinan dari pemerintahan kota dan/atau menjadi kebijakan Developer.',

      // legalitas dan perizinian page
      'legality': 'Legalitas',
      'licenses': 'Perizinan',

      // 'rate_us': "Nilai Kami",
      // Common
      'app_name': 'Dago Valley Explore',
      'welcome': 'Selamat Datang',
      'hello': 'Halo',
      'loading': 'Memuat...',
      'error': 'Terjadi Kesalahan',
      'success': 'Berhasil',
      'cancel': 'Batal',
      'ok': 'OK',
      'save': 'Simpan',
      'delete': 'Hapus',
      'edit': 'Edit',
      'search': 'Cari',
      'settings': 'Pengaturan',
      'type': 'Tipe',

      // Language
      'language': 'Bahasa',
      'language_changed': 'Bahasa Diubah',
      'language_changed_to': 'Bahasa diubah menjadi @lang',
      'indonesian': 'Bahasa Indonesia',
      'english': 'English',

      // Theme
      'theme': 'Tema',
      'dark_mode': 'Mode Gelap',
      'light_mode': 'Mode Terang',
      'theme_changed': 'Tema Diubah',

      // Menu Items
      'home': 'Beranda',
      'dashboard': 'Dasbor',
      'site_plan': 'Site Plan',
      'event': 'Acara',
      'house_type': 'Tipe Rumah',
      'virtual_tour': 'Tur Virtual',
      'calculator': 'Kalkulator',
      'booking': 'Pemesanan',
      'documents': 'Dokumen',

      // Home Page
      'hero_title': 'Lorem Ipsum Dolor Sit Amet',
      'hero_description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
      'see_promo': 'Lihat Promo',
      'rate_us': 'Beri Rating',
      'contact_us': 'Hubungi',

      // Promo
      'promo': 'Promo',
      'book_now': 'Booking Sekarang',
      'booking_promo': 'Booking promo: @title',

      // QR Code
      'scan_qr': 'Scan QR Code',
      'search_dago': 'Cari "Dago Valley" di Google',
      'copy_link': 'Salin Link',
      'share': 'Bagikan',
      'download': 'Unduh',
      'link_copied': 'Link Disalin',
      'link_copied_success': 'Link berhasil disalin ke clipboard',
      'share_feature_coming': 'Fitur bagikan segera hadir',

      // Instructions
      'instruction_1': 'Buka aplikasi kamera atau QR scanner',
      'instruction_2': 'Arahkan ke QR Code di atas',
      'instruction_3': 'Otomatis akan mencari "Dago Valley" di Google',

      // Contact
      'whatsapp': 'WhatsApp',
      'website': 'Website',
      'instagram': 'Instagram',

      // Footer
      'all_rights_reserved': '© 2025 Dago Valley. Hak Cipta Dilindungi.',
    },

    // English
    'en_US': {
      //homepage
      'welcome_title': 'Luxury House in Dago Valley Bandung',
      'welcome_desc':
          'Enjoy the comforts of life with complete facilities and a beautiful environment. Find your dream home in this exclusive residential area.',
      'view_promo': "View Promo",
      'site_plan': "Site Plan",
      'event': "Event",
      'documentation': "Documentation",
      'house_type': "House Type",
      'agreements_and_legality': "Legality & Licences",
      'check_availability': "Check availability",

      // siteplan page
      'siteplan_feature': 'Site Plan Feature',
      'siteplan_feature_desc':
          'Site plan feature is under development. Coming soon: interactive view, zoom, and unit details.',

      // virtual / product page
      'harmoni_desc': 'Comfortable living with modern tropical design',
      'foresta_desc': 'A balance of luxury and natural harmony',
      'tropica_desc': 'Natural beauty with a modern touch',
      'view_details': 'View Details',
      'phase_one': 'Phase 1',
      'phase_two': 'Phase 2',

      // cash calculator page
      'mortgage_simulation': 'Mortgage Simulation',
      'mortgage_simulation_desc':
          'Mortgage simulations help you calculate estimated mortgage payments based on price, down payment, and loan term. With this feature, you can find out your estimated monthly payments to make it easier to plan the purchase of your dream home.',
      'model_and_type': 'Model & Type',
      'choose_house_model': 'Choose House Model',
      'payment_method': 'Payment Method',
      'sharia_bank_mortgage': 'Sharia Bank Mortgage',
      'developer_mortgage': 'Developer Mortgage',
      'tenor': 'Tenor (years)',
      'years': 'Years',
      'no_down_payment': 'No Down Payment',
      'choose_house_model_first': 'Choose House Model First',
      'mortgage_margin': 'Mortgage Margin',
      'discount': 'Discount',
      'summary': 'Summary',
      'installment_table': 'Installment Table',

      'terms_n_conditions': 'Terms & Conditions',
      'terms_one':
          'Prices are not binding and are subject to change at any time without prior notice.',
      'terms_two':
          'Prices include Notary fees, Certificate Splitting, AJB, Certificate BBN & IMB.',
      'terms_three':
          'Prices do not include BPHTB & VAT (if there is a change in VAT rates, the VAT difference will be borne and must be paid by the buyer).',
      'terms_four':
          'Prices include PLN electricity installation fees and clean water supply.',
      'terms_five':
          'Booking Fee payment of Rp. 10,000,000 (non-refundable if the consumer cancels).',
      'terms_six':
          'Cash purchase payment must be made no later than 1 month after the Booking Fee payment.',
      'terms_seven':
          'Down payment for KPR unit purchases must be made no later than 14 days after the Booking Fee payment.',
      'terms_eight':
          'Requirements for KPR unit purchases: FC KTP/Paspor suami & istri, Surat Nikah, KK, NPWP, Rekening Koran 3 bulan terakhir, Slip Gaji, SK awal & akhir.',
      'terms_nine':
          'If there are changes/transfers to the location of the plot that has been previously selected, a fee of Rp. 3,000,000 will be charged.',
      'terms_ten':
          'Payment via cash deposit/bank transfer is addressed to the BSI (Bank Syariah Indonesia) account, number: 722-127-3607, a.n. PT. Cisitu Indah Lestari.',
      'terms_eleven':
          'Indent house building units (building handover 12 months after full DP payment or a minimum payment of 30% of the total price is received by the Developer).',
      'terms_twelve':
          'The area/specifications of the land and buildings are subject to change in accordance with the legal provisions of the National Land Agency (BPN), licensing provisions of the city government, and/or the developers policies.',

      // legalitas dan perizinian page
      'legality': 'Legality',
      'licenses': 'Licenses',

      // 'rate_us': "Rate Us",
      // Common
      'app_name': 'Dago Valley Explore',
      'welcome': 'Welcome',
      'hello': 'Hello',
      'loading': 'Loading...',
      'error': 'An Error Occurred',
      'success': 'Success',
      'cancel': 'Cancel',
      'ok': 'OK',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'search': 'Search',
      'settings': 'Settings',
      'type': 'Type',

      // Language
      'language': 'Language',
      'language_changed': 'Language Changed',
      'language_changed_to': 'Language changed to @lang',
      'indonesian': 'Bahasa Indonesia',
      'english': 'English',

      // Theme
      'theme': 'Theme',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'theme_changed': 'Theme Changed',

      // Menu Items
      'home': 'Home',
      'dashboard': 'Dashboard',
      'site_plan': 'Site Plan',
      'event': 'Event',
      'house_type': 'House Type',
      'virtual_tour': 'Virtual Tour',
      'calculator': 'Calculator',
      'booking': 'Booking',
      'documents': 'Documents',

      // Home Page
      'hero_title': 'Lorem Ipsum Dolor Sit Amet',
      'hero_description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
      'see_promo': 'See Promo',
      'rate_us': 'Rate Us',
      'contact_us': 'Contact',

      // Promo
      'promo': 'Promo',
      'book_now': 'Book Now',
      'booking_promo': 'Booking promo: @title',

      // QR Code
      'scan_qr': 'Scan QR Code',
      'search_dago': 'Search "Dago Valley" on Google',
      'copy_link': 'Copy Link',
      'share': 'Share',
      'download': 'Download',
      'link_copied': 'Link Copied',
      'link_copied_success': 'Link successfully copied to clipboard',
      'share_feature_coming': 'Share feature coming soon',

      // Instructions
      'instruction_1': 'Open camera app or QR scanner',
      'instruction_2': 'Point to the QR Code above',
      'instruction_3': 'Automatically search "Dago Valley" on Google',

      // Contact
      'whatsapp': 'WhatsApp',
      'website': 'Website',
      'instagram': 'Instagram',

      // Footer
      'all_rights_reserved': '© 2025 Dago Valley. All Rights Reserved.',
    },
  };
}
