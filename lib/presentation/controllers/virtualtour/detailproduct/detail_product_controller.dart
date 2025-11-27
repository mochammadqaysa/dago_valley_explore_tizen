import 'package:carousel_slider/carousel_controller.dart' as cs;
import 'package:dago_valley_explore/data/models/house_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class DetailProductController extends GetxController {
  // Carousel controller
  final carouselController = cs.CarouselSliderController();

  // Observable untuk index aktif
  final currentIndex = 0.obs;

  // Observable untuk fullscreen mode
  final isFullscreen = false.obs;

  // TransformationController untuk zoom
  final transformationController = TransformationController();

  // House model yang akan ditampilkan
  final Rx<HouseModel?> houseModel = Rx<HouseModel?>(null);

  // List gambar dan video dari house model
  final RxList<String> images = <String>[].obs;
  final RxList<String> videos = <String>[].obs;

  // Total items (images + videos)
  int get totalItems => images.length + videos.length;

  // Video players
  final Map<int, VideoPlayerController?> videoControllers = {};
  final RxMap<int, bool> videoInitialized = <int, bool>{}.obs;
  final RxMap<int, bool> videoPlaying = <int, bool>{}.obs;
  final RxMap<int, String?> videoErrors = <int, String?>{}.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is HouseModel) {
      houseModel.value = Get.arguments as HouseModel;
      images.value = houseModel.value?.gambar ?? [];
      videos.value = houseModel.value?.video ?? [];

      print('📊 Product Detail Loaded:');
      print('   Model: ${houseModel.value?.model}');
      print('   Type: ${houseModel.value?.type}');
      print('   Images: ${images.length}');
      print('   Videos: ${videos.length}');

      // Initialize videos if available
      if (videos.isNotEmpty) {
        // Delay to avoid startup conflicts
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!isClosed) {
            _initializeVideoPlayers();
          }
        });
      }
    }
  }

  // Check if asset exists
  Future<bool> _checkAssetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Initialize video players with asset
  void _initializeVideoPlayers() async {
    print('\n🎬 Initializing ${videos.length} video(s)...');
    print('   Platform: ${Platform.operatingSystem}');
    print(
      '   Is Tizen: ${Platform.isLinux && Platform.operatingSystem == "linux"} (check for Tizen)',
    );

    for (int i = 0; i < videos.length; i++) {
      final videoIndex = images.length + i;
      final videoPath = videos[i];

      try {
        videoInitialized[videoIndex] = false;
        videoPlaying[videoIndex] = false;
        videoErrors[videoIndex] = null;

        print('\n📹 Video $i: $videoPath');

        // Check if asset exists
        final exists = await _checkAssetExists(videoPath);
        if (!exists) {
          throw Exception('Asset not found: $videoPath');
        }

        // Create controller from asset
        print('   Creating VideoPlayerController from asset...');
        final controller = VideoPlayerController.asset(videoPath);
        videoControllers[videoIndex] = controller;

        // PERBAIKAN: Set properties SEBELUM initialize
        controller.setLooping(true);
        controller.setVolume(1.0);

        // Initialize
        print('   Initializing controller...');
        await controller
            .initialize()
            .then((_) {
              if (!isClosed && controller.value.isInitialized) {
                print('   Video initialized successfully!');
                print('   Duration: ${controller.value.duration}');
                print('   Size: ${controller.value.size}');
                print('   Aspect Ratio: ${controller.value.aspectRatio}');

                // PENTING: Trigger update observable
                videoInitialized[videoIndex] = true;
                videoInitialized.refresh(); // Force refresh

                // Add listener AFTER initialization
                controller.addListener(() {
                  if (!isClosed && videoControllers[videoIndex] != null) {
                    final isCurrentlyPlaying = controller.value.isPlaying;
                    if (videoPlaying[videoIndex] != isCurrentlyPlaying) {
                      videoPlaying[videoIndex] = isCurrentlyPlaying;
                    }

                    // Debug info
                    if (controller.value.hasError) {
                      print(
                        '❌ Video error at index $videoIndex: ${controller.value.errorDescription}',
                      );
                      videoErrors[videoIndex] =
                          controller.value.errorDescription;
                    }
                  }
                });

                // PENTING: Seek ke awal untuk memastikan frame pertama dimuat
                controller.seekTo(Duration.zero).then((_) {
                  // TIZEN FIX: Play and pause immediately untuk render frame pertama
                  if (Platform.isLinux) {
                    print('   🔧 Tizen: Triggering first frame render...');
                    controller.play().then((_) {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (!isClosed && controller.value.isPlaying) {
                          controller.pause();
                          videoPlaying[videoIndex] = false;
                          print('   ✅ First frame rendered!');
                        }
                      });
                    });
                  }
                });

                print('✅ Video ready to play!');
              }
            })
            .catchError((error) {
              if (!isClosed) {
                final errorMsg = 'Init error: $error';
                videoErrors[videoIndex] = errorMsg;
                videoInitialized[videoIndex] = false;
                print('❌ $errorMsg');

                // Dispose failed controller
                try {
                  controller.dispose();
                  videoControllers[videoIndex] = null;
                } catch (e) {
                  print('   Dispose error: $e');
                }
              }
            });

        // Delay between initializations
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e, stackTrace) {
        if (!isClosed) {
          final errorMsg = 'Exception: $e';
          videoErrors[videoIndex] = errorMsg;
          videoInitialized[videoIndex] = false;
          print('❌ $errorMsg');
          print('   Stack: $stackTrace');
        }
      }
    }

    print('\n✅ Video initialization complete\n');
  }

  // Check if current item is video
  bool isVideo(int index) => index >= images.length;

  // Get video controller
  VideoPlayerController? getVideoController(int index) =>
      videoControllers[index];

  // Get video index
  int getVideoIndex(int carouselIndex) => carouselIndex - images.length;

  // Toggle video playback
  void toggleVideoPlayback(int index) {
    try {
      final controller = videoControllers[index];
      if (controller != null &&
          videoInitialized[index] == true &&
          controller.value.isInitialized) {
        print('🎬 Toggling playback for index $index');
        print('   Current state - Playing: ${controller.value.isPlaying}');
        print('   Position: ${controller.value.position}');
        print('   Duration: ${controller.value.duration}');
        print('   Size: ${controller.value.size}');
        print('   Aspect Ratio: ${controller.value.aspectRatio}');
        print('   Has error: ${controller.value.hasError}');

        if (controller.value.isPlaying) {
          controller.pause();
          videoPlaying[index] = false; // Explicit update
          print('⏸️ Video paused at index $index');
        } else {
          controller.play();
          videoPlaying[index] = true; // Explicit update
          print('▶️ Video playing at index $index');
        }

        // Force refresh observable
        videoPlaying.refresh();
      } else {
        print('⚠️ Cannot toggle video at index $index');
        print('   Controller null: ${controller == null}');
        print('   Initialized: ${videoInitialized[index]}');
        if (controller != null) {
          print('   Is initialized: ${controller.value.isInitialized}');
          print('   Has error: ${controller.value.hasError}');
          print('   Error description: ${controller.value.errorDescription}');
        }
      }
    } catch (e) {
      print('❌ Error toggling playback: $e');
    }
  }

  // Pause all videos
  void pauseAllVideos() {
    try {
      videoControllers.forEach((index, controller) {
        if (controller != null &&
            controller.value.isInitialized &&
            controller.value.isPlaying) {
          try {
            controller.pause();
            print('⏸️ Paused video at index $index');
          } catch (e) {
            print('Error pausing video $index: $e');
          }
        }
      });
    } catch (e) {
      print('❌ Error pausing videos: $e');
    }
  }

  // Seek video
  void seekVideo(int index, Duration position) {
    try {
      final controller = videoControllers[index];
      if (controller != null && controller.value.isInitialized) {
        controller.seekTo(position);
      }
    } catch (e) {
      print('❌ Error seeking: $e');
    }
  }

  @override
  void onClose() {
    try {
      print('\n🛑 Disposing controllers...');

      // Dispose video controllers
      final indices = videoControllers.keys.toList();
      for (final index in indices) {
        final controller = videoControllers[index];
        if (controller != null) {
          try {
            if (controller.value.isInitialized && controller.value.isPlaying) {
              controller.pause();
            }
            controller.dispose();
            print('   Disposed controller at index $index');
          } catch (e) {
            print('   Dispose error for index $index: $e');
          }
        }
      }
      videoControllers.clear();

      print('✅ All controllers disposed\n');
    } catch (e) {
      print('❌ onClose error: $e');
    }

    try {
      transformationController.dispose();
    } catch (e) {
      // Ignore
    }

    super.onClose();
  }

  // Set current index
  void setCurrentIndex(int index) {
    pauseAllVideos();
    currentIndex.value = index;

    // Auto play video saat carousel menuju ke video item
    if (isVideo(index)) {
      Future.delayed(const Duration(milliseconds: 500), () {
        final controller = videoControllers[index];
        if (controller != null &&
            videoInitialized[index] == true &&
            controller.value.isInitialized) {
          print('🎬 Auto-playing video at index $index');
          print('   Controller ready: ${controller.value.isInitialized}');
          print('   Size: ${controller.value.size}');
          print('   Duration: ${controller.value.duration}');

          if (!controller.value.isPlaying) {
            // For Tizen: ensure we're at the beginning
            controller.seekTo(Duration.zero).then((_) {
              controller.play();
              videoPlaying[index] = true;
              videoPlaying.refresh();
              print('   ✅ Video started playing');
            });
          }
        } else {
          print('⚠️ Video not ready at index $index');
          if (controller != null) {
            print('   Initialized value: ${controller.value.isInitialized}');
            print('   Has error: ${controller.value.hasError}');
            if (controller.value.hasError) {
              print('   Error: ${controller.value.errorDescription}');
            }
          }
        }
      });
    }
  }

  // Go to page
  void goToPage(int index) {
    carouselController.animateToPage(index);
  }

  // Open fullscreen
  void openFullscreen() {
    isFullscreen.value = true;
  }

  // Close fullscreen
  void closeFullscreen() {
    isFullscreen.value = false;
    transformationController.value = Matrix4.identity();
  }

  // Handle booking
  void bookPromo() {
    if (houseModel.value != null) {
      Get.snackbar(
        'Booking',
        'Booking untuk ${houseModel.value!.model}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  // Close modal
  void closeModal() {
    Get.back();
  }
}
