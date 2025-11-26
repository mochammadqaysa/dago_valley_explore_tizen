import 'package:dago_valley_explore/data/models/house_model.dart';
import 'package:dago_valley_explore/presentation/components/liquidglass/liquid_glass_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final Color? titleBackgroundColor;
  final Color? buttonColor;
  final HouseModel houseModel;

  const ProductCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.buttonText,
    required this.onButtonPressed,
    this.titleBackgroundColor,
    this.buttonColor,
    required this.houseModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onButtonPressed,
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Stack(
            children: [
              // === Layer 1: Gambar ===
              Image.asset(
                imageUrl,
                height: 512,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 400,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 50),
                  );
                },
              ),

              // === (Opsional) Masking gelap supaya teks lebih terlihat ===
              // Container(
              //   height: 400,
              //   width: double.infinity,
              //   color: Colors.black.withOpacity(0.3),
              // ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    // color: titleBackgroundColor ?? Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "type".tr + " ${houseModel.model}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        houseModel.type,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // === Layer 2: Container berisi teks dan tombol ===
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: LiquidGlassContainer(
                  glassColor: Colors.black,
                  glassAccentColor: Colors.grey,
                  showBorder: false,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  borderRadius: 0,
                  blurIntensity: 1,
                  // padding: const EdgeInsets.symmetric(
                  //   horizontal: 16,
                  //   vertical: 12,
                  // ),
                  // decoration: BoxDecoration(
                  //   color: Colors.white.withOpacity(0.9),
                  //   borderRadius: const BorderRadius.only(
                  //     topLeft: Radius.circular(16),
                  //     topRight: Radius.circular(16),
                  //   ),
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Teks
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            buttonText,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          // const SizedBox(height: 4),
                          // const Text(
                          //   'Check Availability',
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     fontWeight: FontWeight.w500,
                          //     color: Colors.white,
                          //   ),
                          // ),
                        ],
                      ),

                      // Tombol
                      // ElevatedButton(
                      //   onPressed: onButtonPressed,
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: buttonColor ?? Colors.white,
                      //     foregroundColor: Colors.black87,
                      //     elevation: 0,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(20),
                      //       side: BorderSide(color: Colors.grey[300]!, width: 1),
                      //     ),
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 12,
                      //       vertical: 8,
                      //     ),
                      //     minimumSize: const Size(40, 40),
                      //   ),
                      //   child: const Icon(Icons.arrow_forward, size: 20),
                      // ),
                      // OutlinedButton(
                      //   onPressed: onButtonPressed,
                      //   style: OutlinedButton.styleFrom(
                      //     foregroundColor: Colors.black87,
                      //     side: BorderSide(color: Colors.grey[300]!, width: 1),
                      //     shape: CircleBorder(),
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 15,
                      //       vertical: 15,
                      //     ),
                      //     minimumSize: const Size(40, 40),
                      //   ),
                      //   child: const Icon(
                      //     Icons.arrow_forward,
                      //     size: 20,
                      //     color: Colors.white,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
