import 'dart:io';
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/presentation/controllers/event/event_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/locale/locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player_win/video_player_win.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;

class EventGalleryPage extends GetView<EventController> {
  const EventGalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.currentEvent.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Galeri',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Event Info Section (di atas Tab Bar)
            _buildEventInfo(localeController),

            const SizedBox(height: 16),

            // Gallery Content
            Expanded(child: _buildGalleryContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildEventInfo(LocaleController localeController) {
    final storage = Get.find<LocalStorageService>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: FutureBuilder<File?>(
                    future: storage.getLocalImage(
                      controller.currentEvent.imageUrl,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          color: Colors.grey[900],
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }

                      final file = snapshot.data;
                      if (file != null && file.existsSync()) {
                        return Image.file(file, fit: BoxFit.cover);
                      }

                      return Container(
                        color: Colors.grey[900],
                        child: const Icon(Icons.image, color: Colors.white54),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Event Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      controller.currentEvent.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      localeController.isIndonesian
                          ? controller.currentEvent.subtitle
                          : controller.currentEvent.en.subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            localeController.isIndonesian
                ? controller.currentEvent.description
                : controller.currentEvent.en.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              height: 1.6,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryContent() {
    final images = controller.currentEvent.images;
    final videos = controller.currentEvent.videos;

    final imageFiles = images
        .where((img) => _isImageFile(img.filePath))
        .toList();
    final videoFiles = videos
        .where((img) => _isVideoFile(img.filePath))
        .toList();
    debugPrint(
      'Image files count: ${imageFiles.length}, Video files count: ${videoFiles.length}',
    );

    if (imageFiles.isEmpty && videoFiles.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada media tersedia',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // Modern Tab Bar with Segmented Control Style
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.5),
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
              tabs: [
                Tab(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image_rounded, size: 20),
                      const SizedBox(width: 8),
                      const Text('Foto'),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${imageFiles.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_circle_rounded, size: 20),
                      const SizedBox(width: 8),
                      const Text('Video'),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${videoFiles.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              children: [
                _buildImageGrid(imageFiles),
                _buildVideoGrid(videoFiles),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(List<dynamic> imageFiles) {
    if (imageFiles.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada foto',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
        ),
      );
    }

    final storage = Get.find<LocalStorageService>();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: imageFiles.length,
      itemBuilder: (context, index) {
        final imageUrl = imageFiles[index].filePath;

        return FutureBuilder<File?>(
          future: storage.getLocalImage(imageUrl),
          builder: (context, snapshot) {
            Widget imageWidget;

            if (snapshot.connectionState == ConnectionState.waiting) {
              imageWidget = Container(
                color: Colors.grey[900],
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              );
            } else {
              final file = snapshot.data;
              if (file != null && file.existsSync()) {
                imageWidget = Image.file(
                  file,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                );
              } else {
                imageWidget = Container(
                  color: Colors.grey[900],
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.white54),
                  ),
                );
              }
            }

            return GestureDetector(
              onTap:
                  snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null
                  ? () => _openImageViewer(imageFiles, index)
                  : null,
              child: Hero(
                tag: 'image_$imageUrl',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageWidget,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVideoGrid(List<dynamic> videoFiles) {
    if (videoFiles.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada video',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
        ),
      );
    }

    final storage = Get.find<LocalStorageService>();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 16 / 9,
      ),
      itemCount: videoFiles.length,
      itemBuilder: (context, index) {
        final videoUrl = videoFiles[index].filePath;

        return FutureBuilder<File?>(
          future: storage.getLocalVideo(videoUrl),
          builder: (context, videoSnapshot) {
            return GestureDetector(
              onTap: () => _openVideoPlayer(videoUrl),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Video Thumbnail using WinVideoPlayer
                    if (videoSnapshot.hasData && videoSnapshot.data != null)
                      _VideoThumbnailWidget(videoFile: videoSnapshot.data!)
                    else if (videoSnapshot.connectionState ==
                        ConnectionState.waiting)
                      Container(
                        color: Colors.grey[900],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    else
                      Container(
                        color: Colors.grey[900],
                        child: const Icon(
                          Icons.video_library_rounded,
                          color: Colors.white54,
                          size: 48,
                        ),
                      ),

                    // Dark gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),

                    // Play button overlay
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),

                    // Video badge (bottom right)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.videocam_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Video',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMediaImage(String imageUrl, {BoxFit fit = BoxFit.cover}) {
    final storage = Get.find<LocalStorageService>();

    return FutureBuilder<File?>(
      future: storage.getLocalImage(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.grey[900],
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          );
        }

        final file = snapshot.data;
        if (file != null && file.existsSync()) {
          return Image.file(file, fit: fit, gaplessPlayback: true);
        }

        return Container(
          color: Colors.grey[900],
          child: const Center(
            child: Icon(Icons.broken_image, color: Colors.white54),
          ),
        );
      },
    );
  }

  void _openImageViewer(List<dynamic> images, int initialIndex) {
    Navigator.of(Get.context!).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.9),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: _ImageViewerPage(images: images, initialIndex: initialIndex),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _openVideoPlayer(String videoUrl) {
    Get.to(
      () => _VideoPlayerPage(videoUrl: videoUrl),
      transition: Transition.fadeIn,
      fullscreenDialog: true,
    );
  }

  bool _isImageFile(String url) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
    final lowerUrl = url.toLowerCase();
    return imageExtensions.any((ext) => lowerUrl.endsWith(ext));
  }

  bool _isVideoFile(String url) {
    final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm', '.flv'];
    final lowerUrl = url.toLowerCase();
    return videoExtensions.any((ext) => lowerUrl.endsWith(ext));
  }
}

// ==================== Video Thumbnail Widget ====================
class _VideoThumbnailWidget extends StatefulWidget {
  final File videoFile;

  const _VideoThumbnailWidget({required this.videoFile});

  @override
  State<_VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<_VideoThumbnailWidget> {
  WinVideoPlayerController? _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    try {
      _controller = WinVideoPlayerController.file(widget.videoFile);
      await _controller!.initialize();
      await _controller!.seekTo(const Duration(seconds: 1));
      await _controller!.pause();
      if (mounted) {
        setState(() => _initialized = true);
      }
    } catch (e) {
      debugPrint('Error initializing video thumbnail: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _controller == null) {
      return Container(
        color: Colors.grey[900],
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        ),
      );
    }

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _controller!.value.size.width,
        height: _controller!.value.size.height,
        child: WinVideoPlayer(_controller!),
      ),
    );
  }
}

// ==================== Image Viewer Page ====================
class _ImageViewerPage extends StatefulWidget {
  final List<dynamic> images;
  final int initialIndex;

  const _ImageViewerPage({required this.images, required this.initialIndex});

  @override
  State<_ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<_ImageViewerPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Carousel
          cs.CarouselSlider.builder(
            itemCount: widget.images.length,
            options: cs.CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              initialPage: widget.initialIndex,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() => _currentIndex = index);
              },
            ),
            itemBuilder: (context, index, realIndex) {
              final imageUrl = widget.images[index].filePath;
              final storage = Get.find<LocalStorageService>();

              return Center(
                child: FutureBuilder<File?>(
                  future: storage.getLocalImage(imageUrl),
                  builder: (context, snapshot) {
                    Widget imageWidget;

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      imageWidget = const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    } else {
                      final file = snapshot.data;
                      if (file != null && file.existsSync()) {
                        imageWidget = Image.file(
                          file,
                          fit: BoxFit.contain,
                          gaplessPlayback: true,
                        );
                      } else {
                        imageWidget = const Icon(
                          Icons.broken_image,
                          color: Colors.white,
                          size: 64,
                        );
                      }
                    }

                    return Hero(
                      tag: 'image_$imageUrl',
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: imageWidget,
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // Close button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentIndex + 1}/${widget.images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
  }
}

// ==================== Video Player Page ====================
class _VideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  const _VideoPlayerPage({required this.videoUrl});

  @override
  State<_VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<_VideoPlayerPage> {
  WinVideoPlayerController? _controller;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final storage = Get.find<LocalStorageService>();
      final videoFile = await storage.getLocalVideo(widget.videoUrl);

      if (videoFile != null && videoFile.existsSync()) {
        _controller = WinVideoPlayerController.file(videoFile);
        await _controller!.initialize();
        await _controller!.play();
        setState(() => _isLoading = false);
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      print('Error initializing video: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _toggleMute() {
    if (_controller != null) {
      setState(() {
        _isMuted = !_isMuted;
        _controller!.setVolume(_isMuted ? 0.0 : 1.0);
      });
    }
  }

  void _togglePlayPause() {
    if (_controller != null) {
      setState(() {
        _controller!.value.isPlaying
            ? _controller!.pause()
            : _controller!.play();
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : _hasError
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.white54,
                        size: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Video tidak dapat diputar',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  )
                : _controller != null && _controller!.value.isInitialized
                ? GestureDetector(
                    onTap: _togglePlayPause,
                    child: AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: WinVideoPlayer(_controller!),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Close button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ),
          ),

          // Video Controls
          if (_controller != null && _controller!.value.isInitialized)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Progress slider
                    ValueListenableBuilder(
                      valueListenable: _controller!,
                      builder: (context, value, child) {
                        final position = value.position.inMilliseconds
                            .toDouble();
                        final duration = value.duration.inMilliseconds
                            .toDouble();

                        return Slider(
                          value: duration > 0 ? position : 0,
                          max: duration > 0 ? duration : 1,
                          onChanged: (newValue) {
                            _controller!.seekTo(
                              Duration(milliseconds: newValue.toInt()),
                            );
                          },
                          activeColor: Colors.white,
                          inactiveColor: Colors.white38,
                        );
                      },
                    ),

                    // Control buttons
                    Row(
                      children: [
                        // Play/Pause button
                        IconButton(
                          icon: ValueListenableBuilder(
                            valueListenable: _controller!,
                            builder: (context, value, child) {
                              return Icon(
                                value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                                size: 28,
                              );
                            },
                          ),
                          onPressed: _togglePlayPause,
                        ),

                        const SizedBox(width: 8),

                        // Mute/Unmute button
                        IconButton(
                          icon: Icon(
                            _isMuted ? Icons.volume_off : Icons.volume_up,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: _toggleMute,
                        ),

                        const Spacer(),

                        // Time display
                        ValueListenableBuilder(
                          valueListenable: _controller!,
                          builder: (context, value, child) {
                            final position = value.position;
                            final duration = value.duration;
                            return Text(
                              '${_formatDuration(position)} / ${_formatDuration(duration)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Play/Pause overlay (center)
          if (_controller != null && _controller!.value.isInitialized)
            Center(
              child: ValueListenableBuilder(
                valueListenable: _controller!,
                builder: (context, value, child) {
                  if (value.isPlaying) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
