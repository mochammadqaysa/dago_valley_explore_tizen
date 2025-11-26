import 'package:dago_valley_explore/app/config/app_colors.dart';
import 'package:dago_valley_explore/app/extensions/color.dart';
import 'package:dago_valley_explore/presentation/components/liquidglass/liquid_glass_button.dart';
import 'package:dago_valley_explore/presentation/components/liquidglass/liquid_glass_container.dart';
import 'package:dago_valley_explore/presentation/controllers/promo/promo_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/qrcode/qrcode_binding.dart';
import 'package:dago_valley_explore/presentation/pages/promo/promo_detail_page.dart';
import 'package:dago_valley_explore/presentation/pages/qrcode/qrcode_page.dart';
import 'package:dago_valley_explore/presentation/components/site_plan_card/site_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DasborAwal extends StatefulWidget {
  const DasborAwal({super.key});

  @override
  State<DasborAwal> createState() => _DasborAwalState();
}

class _DasborAwalState extends State<DasborAwal> {
  void _showPromoModal() {
    // Panggil binding secara manual sesuai pattern Anda
    PromoBinding().dependencies();

    // Navigasi dengan fade transition
    Get.to(
      () => const PromoDetailPage(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 400),
      opaque: false,
      fullscreenDialog: true,
    );
  }

  void _showQRCodeModal() {
    // Panggil binding secara manual sesuai pattern Anda
    QrCodeBinding().dependencies();

    // Navigasi dengan fade transition
    Get.to(
      () => const QRCodePage(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 400),
      opaque: false,
      fullscreenDialog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: HexColor("121212"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // Gambar
                      Image.asset(
                        "assets/1.jpg",
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                      // Overlay hitam
                      Container(color: Colors.black.withOpacity(0.5)),

                      // Text di atas overlay
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Lorem Ipsum Dolor Sit Amet",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            LiquidGlassButton(
                              width: 200,
                              borderRadius: 30,
                              text: 'Lihat Promo',
                              onPressed: _showPromoModal,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Ganti dengan Row + MainAxisAlignment.spaceBetween
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SitePlanCard(
                        title: 'Site Plan',
                        imageUrl: 'assets/siteplan.jpg',
                        buttonText: 'Check',
                        onButtonPressed: () {
                          print('Site Plan pressed!');
                        },
                        titleBackgroundColor: Colors.white,
                        buttonColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: SitePlanCard(
                        title: 'Event',
                        imageUrl: 'assets/event.jpg',
                        buttonText: 'Check',
                        onButtonPressed: () {
                          print('Event pressed!');
                        },
                        titleBackgroundColor: Colors.white,
                        buttonColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: SitePlanCard(
                        title: 'Tipe Rumah',
                        imageUrl: 'assets/tiperumah.jpg',
                        buttonText: 'Check',
                        onButtonPressed: () {
                          print('Tipe Rumah pressed!');
                        },
                        titleBackgroundColor: Colors.white,
                        buttonColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: SitePlanCard(
                        title: 'Perjanjian & Legalitas',
                        imageUrl: 'assets/akad.jpg',
                        buttonText: 'Check',
                        onButtonPressed: () {
                          print('Akad pressed!');
                        },
                        titleBackgroundColor: Colors.white,
                        buttonColor: Colors.white,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 17),
                LiquidGlassContainer(
                  glassColor: Colors.black,
                  glassAccentColor: Colors.black,
                  height: 90,
                  width: double.infinity,
                  borderRadius: 17,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              // WhatsApp
                              SvgPicture.asset(
                                "assets/whatsapp.svg",
                                color: Colors.white,
                                height: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "+6289765345729",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 20),

                              // Website
                              SvgPicture.asset(
                                "assets/web.svg",
                                color: Colors.white,
                                height: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "dagovalleybandung.com",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 20),

                              // Instagram
                              SvgPicture.asset(
                                "assets/instagram.svg",
                                color: Colors.white,
                                height: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "@dagovalleybandung",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Tombol di kanan - Trigger QR Modal
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 6,
                        ),
                        child: LiquidGlassButton(
                          borderRadius: 16,
                          text: 'Rate Us',
                          icon: Icons.qr_code_2,
                          glassColor: Colors.grey.withOpacity(0.3),
                          onPressed: _showQRCodeModal, // Panggil QR Modal
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
