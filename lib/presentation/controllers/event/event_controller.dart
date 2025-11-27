import 'package:carousel_slider/carousel_controller.dart' as cs;
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/domain/entities/event.dart';
import 'package:dago_valley_explore/presentation/pages/event/event_gallery/event_gallery_page.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart'; // Tambahkan import ini
import 'dart:io';

class EventController extends GetxController {
  EventController();

  final LocalStorageService _storage = Get.find<LocalStorageService>();

  // Carousel controller
  final carouselController = cs.CarouselSliderController();

  // Observable untuk index aktif
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  // Observable untuk list events
  final _events = RxList<Event>([]);
  List<Event> get events => _events;

  // Video players management
  final Map<String, VideoPlayerController?> videoControllers = {};
  final RxMap<String, bool> videoInitialized = <String, bool>{}.obs;
  final RxMap<String, bool> videoPlaying = <String, bool>{}.obs;
  final RxMap<String, String?> videoErrors = <String, String?>{}.obs;

  // Current event
  Event get currentEvent {
    if (_events.isEmpty) {
      throw Exception('No events available');
    }
    return _events[_currentIndex.value];
  }

  @override
  void onInit() {
    super.onInit();
    loadEvents();
  }

  @override
  void onClose() {
    disposeAllVideos();
    super.onClose();
  }

  void loadEvents() {
    final cachedEvents = _storage.events;
    if (cachedEvents != null && cachedEvents.isNotEmpty) {
      print('✅ Using cached events: ${cachedEvents.length} items');
      _events.assignAll(cachedEvents);
    } else {
      print('⚠️ No events available, using empty list');
      _events.clear();
    }
  }

  // Initialize video for playback
  Future<void> initializeVideo(String videoUrl) async {
    if (videoControllers.containsKey(videoUrl) &&
        videoControllers[videoUrl] != null) {
      return; // Already initialized
    }

    try {
      videoInitialized[videoUrl] = false;
      videoPlaying[videoUrl] = false;
      videoErrors[videoUrl] = null;

      final videoFile = await _storage.getLocalVideo(videoUrl);

      if (videoFile == null || !videoFile.existsSync()) {
        throw Exception('Video file not found: $videoUrl');
      }

      print('📹 Initializing video: $videoUrl');

      final controller = VideoPlayerController.file(videoFile);
      videoControllers[videoUrl] = controller;

      controller.setLooping(true);
      controller.setVolume(1.0);

      await controller.initialize();

      if (!isClosed && controller.value.isInitialized) {
        print('✅ Video initialized: $videoUrl');
        videoInitialized[videoUrl] = true;
        videoInitialized.refresh();

        controller.addListener(() {
          if (!isClosed && videoControllers[videoUrl] != null) {
            final isCurrentlyPlaying = controller.value.isPlaying;
            if (videoPlaying[videoUrl] != isCurrentlyPlaying) {
              videoPlaying[videoUrl] = isCurrentlyPlaying;
            }

            if (controller.value.hasError) {
              videoErrors[videoUrl] = controller.value.errorDescription;
            }
          }
        });

        // Seek to beginning
        await controller.seekTo(Duration.zero);

        // For Tizen: trigger first frame render
        if (Platform.isLinux) {
          controller.play().then((_) {
            Future.delayed(const Duration(milliseconds: 100), () {
              if (!isClosed && controller.value.isPlaying) {
                controller.pause();
                videoPlaying[videoUrl] = false;
              }
            });
          });
        }
      }
    } catch (e) {
      if (!isClosed) {
        final errorMsg = 'Init error: $e';
        videoErrors[videoUrl] = errorMsg;
        videoInitialized[videoUrl] = false;
        print('❌ $errorMsg');

        try {
          videoControllers[videoUrl]?.dispose();
          videoControllers[videoUrl] = null;
        } catch (e) {
          print('Dispose error: $e');
        }
      }
    }
  }

  // Get video controller
  VideoPlayerController? getVideoController(String videoUrl) {
    return videoControllers[videoUrl];
  }

  // Toggle video playback
  void toggleVideoPlayback(String videoUrl) {
    try {
      final controller = videoControllers[videoUrl];
      if (controller != null &&
          videoInitialized[videoUrl] == true &&
          controller.value.isInitialized) {
        if (controller.value.isPlaying) {
          controller.pause();
          videoPlaying[videoUrl] = false;
          print('⏸️ Video paused: $videoUrl');
        } else {
          controller.play();
          videoPlaying[videoUrl] = true;
          print('▶️ Video playing: $videoUrl');
        }

        videoPlaying.refresh();
      }
    } catch (e) {
      print('❌ Error toggling playback: $e');
    }
  }

  // Pause all videos
  void pauseAllVideos() {
    try {
      videoControllers.forEach((videoUrl, controller) {
        if (controller != null &&
            controller.value.isInitialized &&
            controller.value.isPlaying) {
          try {
            controller.pause();
            videoPlaying[videoUrl] = false;
            print('⏸️ Paused video: $videoUrl');
          } catch (e) {
            print('Error pausing video $videoUrl: $e');
          }
        }
      });
    } catch (e) {
      print('❌ Error pausing videos: $e');
    }
  }

  // Seek video
  void seekVideo(String videoUrl, Duration position) {
    try {
      final controller = videoControllers[videoUrl];
      if (controller != null && controller.value.isInitialized) {
        controller.seekTo(position);
      }
    } catch (e) {
      print('❌ Error seeking: $e');
    }
  }

  // Dispose specific video
  void disposeVideo(String videoUrl) {
    try {
      final controller = videoControllers[videoUrl];
      if (controller != null) {
        if (controller.value.isInitialized && controller.value.isPlaying) {
          controller.pause();
        }
        controller.dispose();
        videoControllers.remove(videoUrl);
        videoInitialized.remove(videoUrl);
        videoPlaying.remove(videoUrl);
        videoErrors.remove(videoUrl);
        print('🗑️ Disposed video: $videoUrl');
      }
    } catch (e) {
      print('❌ Error disposing video: $e');
    }
  }

  // Dispose all videos
  void disposeAllVideos() {
    try {
      print('\n🛑 Disposing all video controllers...');

      final videoUrls = videoControllers.keys.toList();
      for (final videoUrl in videoUrls) {
        disposeVideo(videoUrl);
      }

      print('✅ All video controllers disposed\n');
    } catch (e) {
      print('❌ Error disposing videos: $e');
    }
  }

  // Set index carousel
  void setCurrentIndex(int index) {
    _currentIndex.value = index;
  }

  // Go to specific page
  void goToPage(int index) {
    carouselController.animateToPage(index);
  }

  // Handle booking action
  void bookEvent() {
    Get.snackbar(
      'Booking',
      'Booking event: ${currentEvent.title}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Open gallery page
  void openGallery() {
    Get.to(
      () => EventGalleryPage(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // Close modal
  void closeModal() {
    pauseAllVideos();
    Get.back();
  }
}
