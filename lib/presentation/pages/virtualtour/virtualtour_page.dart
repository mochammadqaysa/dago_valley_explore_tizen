import 'package:dago_valley_explore/app/config/app_colors.dart';
import 'package:dago_valley_explore/data/models/house_model.dart';
import 'package:dago_valley_explore/presentation/components/productcard/product_card.dart';
import 'package:dago_valley_explore/presentation/controllers/panoramic/panoramic_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/virtualtour/detailproduct/detail_product_binding.dart';
import 'package:dago_valley_explore/presentation/pages/panoramic_page/panoramic_page.dart';
import 'package:dago_valley_explore/presentation/pages/virtualtour/detail_product/detail_product_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../detail/detail_page.dart';

class VirtualtourPage extends StatefulWidget {
  const VirtualtourPage({super.key});

  @override
  State<VirtualtourPage> createState() => _VirtualtourPageState();
}

class _VirtualtourPageState extends State<VirtualtourPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  void _showProductModal(HouseModel house) {
    // Panggil binding secara manual sesuai pattern Anda
    DetailProductBinding().dependencies();

    // Navigasi dengan fade transition dan pass house model sebagai argument
    Get.to(
      () => const ProductDetailPage(),
      arguments: house, // Pass house model di sini
      transition: Transition.fade,
      duration: const Duration(milliseconds: 400),
      opaque: false,
      fullscreenDialog: true,
    );
  }

  void _showPanoramicView() {
    // Panggil binding secara manual sesuai pattern Anda
    PanoramicBinding().dependencies();

    // Navigasi dengan fade transition dan pass house model sebagai argument
    Get.to(
      () => const PanoramicPage(),
      // arguments: house, // Pass house model di sini
      transition: Transition.fade,
      duration: const Duration(milliseconds: 400),
      opaque: false,
      fullscreenDialog: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      return Scaffold(
        body: Column(
          children: [
            // Header dengan Tab Buttons di pojok kanan atas
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                right: 24,
                left: 24,
                bottom: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Title
                  // Text(
                  //   'Virtual Tour',
                  //   style: TextStyle(
                  //     fontSize: 32,
                  //     fontWeight: FontWeight.bold,
                  //     color: themeController.isDarkMode
                  //         ? Colors.white
                  //         : Colors.black,
                  //   ),
                  // ),

                  // Tab Control Buttons
                  Container(
                    width: 380, // Fixed width untuk TabBar
                    height: 45,
                    decoration: BoxDecoration(
                      color: themeController.isDarkMode
                          ? Colors.grey[850]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: themeController.isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: [
                        Tab(text: 'phase_one'.tr),
                        Tab(text: 'phase_two'.tr),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // TabBarView Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Foresta & Harmoni
                  _buildTab1Content(themeController),

                  // Tab 2: Other Models
                  _buildTab2Content(themeController),
                ],
              ),
            ),
          ],
        ),

        floatingActionButton: Container(
          margin: const EdgeInsets.only(top: 15, right: 650),
          child: FloatingActionButton.extended(
            onPressed: () => _showPanoramicView(),
            backgroundColor: AppColors.primary,
            label: Text(
              "Jelajahi 360 Panoramic View",
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(Icons.threesixty_rounded, color: Colors.white),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      );
    });
  }

  // ===== TAB 1: Foresta & Harmoni =====
  Widget _buildTab1Content(ThemeController themeController) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // SECTION HARMONI
            _buildSectionHeader(
              title: 'Harmoni',
              subtitle: 'harmoni_desc'.tr,
              themeController: themeController,
            ),
            const SizedBox(height: 20),
            _buildHorizontalHouseList(
              useAspectRatio: true,
              modelFilter: 'Harmoni',
              tahapFilter: '1',
            ),

            const SizedBox(height: 40),

            // SECTION FORESTA
            _buildSectionHeader(
              title: 'Foresta',
              subtitle: 'foresta_desc'.tr,
              themeController: themeController,
            ),
            const SizedBox(height: 20),
            _buildHorizontalHouseList(
              useAspectRatio: true,
              modelFilter: 'Foresta',
              tahapFilter: '1',
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ===== TAB 2: Other Models =====
  Widget _buildTab2Content(ThemeController themeController) {
    // Get unique models excluding Foresta and Harmoni
    final otherModels = houseModels
        .where(
          (house) =>
              house.tahap != 'Foresta' &&
              house.model != 'Harmoni' &&
              house.tahap != '1',
        )
        .map((house) => house.model)
        .toSet()
        .toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Generate sections for each other model
            ...otherModels.map((model) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    title: model,
                    subtitle: 'tropica_desc'.tr,
                    themeController: themeController,
                  ),
                  const SizedBox(height: 20),
                  _buildHorizontalHouseList(
                    useAspectRatio: true,
                    modelFilter: model,
                    tahapFilter: '2',
                  ),
                  const SizedBox(height: 40),
                ],
              );
            }).toList(),

            // Jika tidak ada model lain
            if (otherModels.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.home_work_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No other models available',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ===== Widget Header Reusable =====
  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required ThemeController themeController,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: themeController.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16),
          padding: const EdgeInsets.only(left: 16),
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: themeController.isDarkMode ? Colors.white : Colors.black,
                width: 2,
              ),
            ),
          ),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 18,
              color: themeController.isDarkMode
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // ===== Widget Horizontal List Reusable =====
  Widget _buildHorizontalHouseList({
    bool useAspectRatio = false,
    String modelFilter = 'Harmoni',
    String tahapFilter = '1',
  }) {
    final filteredHouses = houseModels
        .where(
          (house) => house.model == modelFilter && house.tahap == tahapFilter,
        )
        .toList();

    if (filteredHouses.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filteredHouses.map((house) {
          // Faktor skala
          final double scaleFactor = useAspectRatio ? 1.5 : 1.0;
          final double baseWidth = 181;
          final double baseHeight = 242;

          return GestureDetector(
            onTap: () {
              // Get.to(() => DetailPage(houseModel: house));
            },
            child: Container(
              width: baseWidth * scaleFactor,
              height: baseHeight * scaleFactor,
              margin: const EdgeInsets.only(right: 16),
              child: _buildHouseCard(house),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ===== Widget Kartu Rumah =====
  Widget _buildHouseCard(HouseModel house) {
    return ProductCard(
      title: house.model,
      imageUrl: house.gambar.first,
      buttonText: 'view_details'.tr,
      onButtonPressed: () => _showProductModal(house),
      titleBackgroundColor: Colors.white.withOpacity(0.8),
      buttonColor: Colors.blueAccent,
      houseModel: house,
    );
  }
}
