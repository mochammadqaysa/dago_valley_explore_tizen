import 'package:dago_valley_explore/presentation/components/liquidglass/liquid_glass_container.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SitePlanCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final Color? titleBackgroundColor;
  final Color? buttonColor;

  const SitePlanCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.buttonText,
    required this.onButtonPressed,
    this.titleBackgroundColor,
    this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    // Wrap reactive parts with Obx so it rebuilds when isDarkMode changes
    return Obx(() {
      final isDark = themeController.isDarkMode;

      return InkWell(
        onTap: onButtonPressed,
        child: Container(
          width: 400,
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: Stack(
              children: [
                // Image layer
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

                // Title label
                // Positioned(
                //   top: 0,
                //   left: 0,
                //   child: Container(
                //     width: 200,
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 16,
                //       vertical: 8,
                //     ),
                //     decoration: BoxDecoration(
                //       color:
                //           titleBackgroundColor ??
                //           (isDark
                //               ? Colors.black.withOpacity(0.6)
                //               : Colors.white.withOpacity(0.9)),
                //       borderRadius: const BorderRadius.only(
                //         topLeft: Radius.circular(8),
                //         bottomRight: Radius.circular(8),
                //       ),
                //     ),
                //     child: Text(
                //       title,
                //       style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w600,
                //         color: isDark ? Colors.white : Colors.black87,
                //       ),
                //     ),
                //   ),
                // ),

                // Liquid glass bottom area (pass colors in)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LiquidGlassContainer(
                    key: ValueKey(
                      isDark,
                    ), // force recreation if LiquidGlass caches internals
                    glassColor: isDark
                        ? Colors.black.withOpacity(0.6)
                        : Colors.black.withOpacity(0.4),
                    glassAccentColor: isDark
                        ? Colors.grey[700]!
                        : Colors.grey[300]!,
                    showBorder: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    borderRadius: 0,
                    blurIntensity: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        OutlinedButton(
                          onPressed: onButtonPressed,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: BorderSide(
                              color: isDark
                                  ? Colors.white24
                                  : Colors.grey[300]!,
                              width: 1,
                            ),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            minimumSize: const Size(40, 40),
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
