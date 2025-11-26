import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dago_valley_explore/presentation/controllers/locale/locale_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';

class LanguageToggleWidget extends StatelessWidget {
  const LanguageToggleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode;
      final isEnglish = localeController.isEnglish;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Language Indicator (ID / EN)
            // AnimatedSwitcher(
            //   duration: const Duration(milliseconds: 300),
            //   transitionBuilder: (child, animation) {
            //     return FadeTransition(
            //       opacity: animation,
            //       child: SlideTransition(
            //         position: Tween<Offset>(
            //           begin: const Offset(0, -0.3),
            //           end: Offset.zero,
            //         ).animate(animation),
            //         child: child,
            //       ),
            //     );
            //   },
            //   child: Text(
            //     localeController.currentLanguageCode,
            //     key: ValueKey(localeController.currentLanguageCode),
            //     style: TextStyle(
            //       color: isDark ? Colors.white : Colors.grey[800],
            //       fontWeight: FontWeight.bold,
            //       fontSize: 16,
            //       letterSpacing: 1.2,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 8),

            // Toggle Switch
            GestureDetector(
              onTap: () {
                localeController.toggleLocale();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: isEnglish
                      ? Colors.teal
                      : Colors.grey[isDark ? 700 : 400],
                ),
                child: Stack(
                  children: [
                    // Background Labels
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ID',
                              style: TextStyle(
                                color: isEnglish
                                    ? Colors.white54
                                    : Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'EN',
                              style: TextStyle(
                                color: isEnglish
                                    ? Colors.white
                                    : Colors.white54,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Sliding Circle
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      left: isEnglish ? 32 : 2,
                      top: 2,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.language,
                            size: 14,
                            color: isEnglish ? Colors.teal : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
