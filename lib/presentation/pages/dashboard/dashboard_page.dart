import 'package:dago_valley_explore/app/config/app_colors.dart';
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/app/types/tab_type.dart';
import 'package:dago_valley_explore/presentation/components/liquidglass/liquid_glass_button.dart';
import 'package:dago_valley_explore/presentation/components/liquidglass/liquid_glass_container.dart';
import 'package:dago_valley_explore/presentation/controllers/event/event_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/locale/locale_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/promo/promo_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/qrcode/qrcode_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/sidebar/sidebar_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:dago_valley_explore/presentation/pages/event/event_detail_page.dart';
import 'package:dago_valley_explore/presentation/pages/promo/promo_detail_page.dart';
import 'package:dago_valley_explore/presentation/pages/qrcode/qrcode_page.dart';
import 'package:dago_valley_explore/presentation/components/site_plan_card/site_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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

  void _showEventModal() {
    // Panggil binding secara manual sesuai pattern Anda
    EventBinding().dependencies();

    // Navigasi dengan fade transition
    Get.to(
      () => EventDetailPage(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 400),
      opaque: false,
      fullscreenDialog: true,
    );
  }

  // Method untuk navigasi ke tab lain via sidebar
  void _navigateToTab(TabType tab) {
    final sidebarController = Get.find<SidebarController>();
    sidebarController.setActiveTab(tab);
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final localeController = Get.find<LocaleController>();
    final _storage = Get.find<LocalStorageService>();
    return Obx(() {
      return Scaffold(
        // backgroundColor: HexColor("121212"),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Container(
                    // height: 400,
                    height: MediaQuery.of(context).size.height * 0.37,
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
                                "welcome_title".tr,
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                localeController.isEnglish
                                    ? _storage.housings?.welcomeTextEn ??
                                          "welcome_desc"
                                    : _storage.housings?.welcomeText ??
                                          "welcome_desc",
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
                                text: 'view_promo'.tr,
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
                  Container(
                    height: MediaQuery.of(context).size.height * 0.475,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SitePlanCard(
                            title: 'site_plan'.tr,
                            imageUrl: 'assets/siteplan.jpg',
                            buttonText: 'check_availability'.tr,
                            onButtonPressed: () {
                              // Navigate ke SitePlanPage via sidebar
                              _navigateToTab(TabType.siteplanpage);
                            },
                            titleBackgroundColor: themeController.isDarkMode
                                ? Colors.black
                                : Colors.white,
                            buttonColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: SitePlanCard(
                            title: 'house_type'.tr,
                            imageUrl: 'assets/tiperumah.jpg',
                            buttonText: 'check_availability'.tr,
                            onButtonPressed: () {
                              // Navigate ke VirtualTourPage (Product Page) via sidebar
                              _navigateToTab(TabType.productpage);
                            },
                            titleBackgroundColor: themeController.isDarkMode
                                ? Colors.black
                                : Colors.white,
                            buttonColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: SitePlanCard(
                            title: 'agreements_and_legality'.tr,
                            imageUrl: 'assets/akad.jpg',
                            buttonText: 'check_availability'.tr,
                            onButtonPressed: () {
                              // Navigate ke LicenseLegalDocumentPage via sidebar
                              _navigateToTab(TabType.licenselegaldocumentpage);
                            },
                            titleBackgroundColor: themeController.isDarkMode
                                ? Colors.black
                                : Colors.white,
                            buttonColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: SitePlanCard(
                            title: 'event'.tr,
                            imageUrl: 'assets/event.jpg',
                            buttonText: 'check_availability'.tr,
                            onButtonPressed: _showEventModal,
                            titleBackgroundColor: themeController.isDarkMode
                                ? Colors.black
                                : Colors.white,
                            buttonColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),
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
                              horizontal: 24,
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
                            text: 'rate_us'.tr,
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
    });
  }
}
