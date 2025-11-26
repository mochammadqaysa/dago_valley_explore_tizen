import 'dart:convert';
import 'dart:typed_data';
import 'package:dago_valley_explore/app/config/app_colors.dart';
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/presentation/controllers/qrcode/qrcode_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:dago_valley_explore/presentation/pages/qrcode/qrcode_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class LicenseLegalDocumentPage extends StatefulWidget {
  const LicenseLegalDocumentPage({Key? key}) : super(key: key);

  @override
  State<LicenseLegalDocumentPage> createState() =>
      _LicenseLegalDocumentPageState();
}

class _LicenseLegalDocumentPageState extends State<LicenseLegalDocumentPage>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _tahap1TabController;
  late TabController _tahap2TabController;

  // Data untuk setiap kategori
  Map<String, List<String>> pdfFiles = {
    'tahap_1_legalitas': [],
    'tahap_1_perizinan': [],
    'tahap_2_legalitas': [],
    'tahap_2_perizinan': [],
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _tahap1TabController = TabController(length: 2, vsync: this);
    _tahap2TabController = TabController(length: 2, vsync: this);

    // Listen to main tab changes to update sub tab controller
    _mainTabController.addListener(() {
      if (_mainTabController.indexIsChanging) {
        setState(() {});
      }
    });

    loadPdfList();
  }

  void _showQRCodeModal([String? url]) {
    // If caller didn't pass URL, try get from local storage (Brochure list)
    if (url == null || url.isEmpty) {
      try {
        final storage = Get.find<LocalStorageService>();
        // Assuming LocalStorageService has a 'brochures' getter returning List<Brochure>?
        // Adjust field name if your implementation uses a different property.
        final brochures = storage.brochures;
        print('Fetched brochures from local storage: $brochures');
        if (brochures != null && brochures.isNotEmpty) {
          final first = brochures.first;
          // Brochure entity should have imageUrl property; adjust if different
          url = (first.imageUrl ?? '').toString();
        }
      } catch (e) {
        if (kDebugMode)
          print('Error fetching brochures from local storage: $e');
      }
    }

    if (url == null || url.isEmpty) {
      Get.snackbar(
        'QR Code',
        'Tidak ada URL brochure yang tersedia.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Navigate to QRCodePage and pass the url via arguments; binding will create controller with this arg
    Get.to(
      () => const QRCodePage(),
      binding: QrCodeBinding(),
      arguments: url,
      transition: Transition.fade,
      duration: const Duration(milliseconds: 400),
      opaque: false,
      fullscreenDialog: true,
    );
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _tahap1TabController.dispose();
    _tahap2TabController.dispose();
    super.dispose();
  }

  Future<void> loadPdfList() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Load Tahap 1 - Legalitas
      final tahap1Legalitas = manifestMap.keys
          .where(
            (String key) =>
                key.startsWith('assets/tahap_1/legalitas/') &&
                key.endsWith('.pdf'),
          )
          .toList();

      // Load Tahap 1 - Perizinan
      final tahap1Perizinan = manifestMap.keys
          .where(
            (String key) =>
                key.startsWith('assets/tahap_1/perizinan/') &&
                key.endsWith('.pdf'),
          )
          .toList();

      // Load Tahap 2 - Legalitas
      final tahap2Legalitas = manifestMap.keys
          .where(
            (String key) =>
                key.startsWith('assets/tahap_2/legalitas/') &&
                key.endsWith('.pdf'),
          )
          .toList();

      // Load Tahap 2 - Perizinan
      final tahap2Perizinan = manifestMap.keys
          .where(
            (String key) =>
                key.startsWith('assets/tahap_2/perizinan/') &&
                key.endsWith('.pdf'),
          )
          .toList();

      setState(() {
        pdfFiles['tahap_1_legalitas'] = tahap1Legalitas
            .map((e) => e.split('/').last)
            .toList();
        pdfFiles['tahap_1_perizinan'] = tahap1Perizinan
            .map((e) => e.split('/').last)
            .toList();
        pdfFiles['tahap_2_legalitas'] = tahap2Legalitas
            .map((e) => e.split('/').last)
            .toList();
        pdfFiles['tahap_2_perizinan'] = tahap2Perizinan
            .map((e) => e.split('/').last)
            .toList();
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading PDF list: $e');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> openPdf(String fileName, String title, String basePath) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PdfViewerPage(assetPath: '$basePath/$fileName', title: title),
      ),
    );
  }

  TabController get _activeSubTabController {
    return _mainTabController.index == 0
        ? _tahap1TabController
        : _tahap2TabController;
  }

  @override
  Widget build(BuildContext context) {
    final isTV = MediaQuery.of(context).size.width > 800;
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDarkMode = themeController.themeMode == ThemeMode.dark;
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              _showQRCodeModal(), // panggil tanpa arg -> ambil dari localstorage
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.file_open_rounded, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Column(
                children: [
                  // Combined TabBar Row (Tahap & Legalitas/Perizinan)
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // Main TabBar (Tahap 1 / Tahap 2) with Outline
                        SizedBox(
                          width: 200,
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isDarkMode
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TabBar(
                              controller: _mainTabController,
                              indicator: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              labelColor: Colors.white,
                              unselectedLabelColor: isDarkMode
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
                        ),
                        const SizedBox(width: 16),
                        // Sub TabBar (Legalitas / Perizinan) with Outline
                        SizedBox(
                          width: 200,
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isDarkMode
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TabBar(
                              controller: _activeSubTabController,
                              indicator: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              labelColor: Colors.white,
                              unselectedLabelColor: isDarkMode
                                  ? Colors.white70
                                  : Colors.black54,
                              labelStyle: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              tabs: [
                                Tab(text: 'legality'.tr),
                                Tab(text: 'licenses'.tr),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // TabBarView untuk Tahap 1 dan Tahap 2
                  Expanded(
                    child: TabBarView(
                      controller: _mainTabController,
                      children: [
                        // Tahap 1 Content
                        _buildTahapContent(
                          isDarkMode,
                          isTV,
                          _tahap1TabController,
                          'tahap_1',
                        ),
                        // Tahap 2 Content
                        _buildTahapContent(
                          isDarkMode,
                          isTV,
                          _tahap2TabController,
                          'tahap_2',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      );
    });
  }

  Widget _buildTahapContent(
    bool isDarkMode,
    bool isTV,
    TabController tabController,
    String tahap,
  ) {
    return TabBarView(
      controller: tabController,
      children: [
        // Legalitas
        _buildPdfGrid(
          isDarkMode,
          isTV,
          pdfFiles['${tahap}_legalitas']!,
          'assets/$tahap/legalitas',
        ),
        // Perizinan
        _buildPdfGrid(
          isDarkMode,
          isTV,
          pdfFiles['${tahap}_perizinan']!,
          'assets/$tahap/perizinan',
        ),
      ],
    );
  }

  Widget _buildPdfGrid(
    bool isDarkMode,
    bool isTV,
    List<String> files,
    String basePath,
  ) {
    final crossAxisCount = isTV ? 5 : 1;

    if (files.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 64,
              color: isDarkMode ? Colors.white38 : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada file PDF',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: isTV ? 1.1 : 2.5,
      ),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final fileName = files[index];
        return GestureDetector(
          onTap: () => openPdf(fileName, fileName, basePath),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDarkMode
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.black.withOpacity(0.4)
                        : Colors.grey.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PdfFileIcon(),
                  const SizedBox(height: 12),
                  Text(
                    fileName.replaceAll('.pdf', '').toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.grey,
                      fontSize: isTV ? 18 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Widget ikon seperti berkas dengan tulisan "PDF"
class _PdfFileIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.insert_drive_file, size: 90, color: Colors.grey.shade600),
        Positioned(
          bottom: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'PDF',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// PdfViewerPage tetap sama seperti kode asli Anda
class PdfViewerPage extends StatefulWidget {
  final String assetPath;
  final String title;

  const PdfViewerPage({Key? key, required this.assetPath, required this.title})
    : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 0;
  double _currentZoom = 1.0;
  bool _showSidebar = true;
  final TextEditingController _pageController = TextEditingController();
  final ScrollController _thumbnailScrollController = ScrollController();
  Uint8List? _pdfBytes;

  final List<double> _zoomLevels = [
    0.25,
    0.33,
    0.5,
    0.67,
    0.75,
    0.8,
    0.9,
    1.0,
    1.1,
    1.25,
    1.5,
    1.75,
    2.0,
    2.5,
    3.0,
    4.0,
    5.0,
  ];

  @override
  void initState() {
    super.initState();
    _initializePdf();
    _pageController.text = '1';
  }

  Future<void> _initializePdf() async {
    try {
      if (kDebugMode) {
        print('Loading PDF from: ${widget.assetPath}');
      }

      try {
        final ByteData data = await rootBundle.load(widget.assetPath);
        _pdfBytes = data.buffer.asUint8List();

        if (kDebugMode) {
          print('PDF bytes loaded successfully: ${_pdfBytes?.length} bytes');
          if (_pdfBytes != null && _pdfBytes!.length > 4) {
            final header = String.fromCharCodes(_pdfBytes!.sublist(0, 4));
            print('PDF Header: $header (should be %PDF)');
          }
        }

        if (_pdfBytes == null || _pdfBytes!.isEmpty) {
          throw Exception('PDF file is empty');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error loading PDF bytes: $e');
        }
        setState(() {
          _error =
              'Gagal memuat file PDF: $e\n\nPastikan file PDF ada di folder yang sesuai';
          _isLoading = false;
        });
        return;
      }

      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          _applyZoom();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in _initializePdf: $e');
      }
      if (mounted) {
        setState(() {
          _error = 'Gagal memuat PDF: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _applyZoom() {
    try {
      if (_currentZoom >= 1.0) {
        _pdfViewerController.zoomLevel = _currentZoom;
      } else {
        _pdfViewerController.zoomLevel = 1.0;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error applying zoom: $e');
      }
    }
  }

  void _onDocumentLoaded(PdfDocumentLoadedDetails details) {
    if (kDebugMode) {
      print(
        'Document loaded successfully. Total pages: ${details.document.pages.count}',
      );
    }
    setState(() {
      _totalPages = details.document.pages.count;
      _error = null;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _applyZoom();
      }
    });
  }

  void _onPageChanged(PdfPageChangedDetails details) {
    setState(() {
      _currentPage = details.newPageNumber;
      _pageController.text = _currentPage.toString();
    });
  }

  void _goToPage(int page) {
    if (page > 0 && page <= _totalPages) {
      _pdfViewerController.jumpToPage(page);
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      _pdfViewerController.nextPage();
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      _pdfViewerController.previousPage();
    }
  }

  void _zoomIn() {
    final nextZoom = _zoomLevels.firstWhere(
      (level) => level > _currentZoom + 0.01,
      orElse: () => _zoomLevels.last,
    );
    setState(() {
      _currentZoom = nextZoom;
    });
    _applyZoom();
  }

  void _zoomOut() {
    final previousZoom = _zoomLevels.lastWhere(
      (level) => level < _currentZoom - 0.01,
      orElse: () => _zoomLevels.first,
    );
    setState(() {
      _currentZoom = previousZoom;
    });
    _applyZoom();
  }

  void _setZoom(double zoom) {
    setState(() {
      _currentZoom = zoom;
    });
    _applyZoom();
  }

  void _resetZoom() {
    setState(() {
      _currentZoom = 1.0;
    });
    _applyZoom();
  }

  void _toggleSidebar() {
    setState(() {
      _showSidebar = !_showSidebar;
    });
  }

  void _showZoomMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width / 2,
        100,
        MediaQuery.of(context).size.width / 2,
        0,
      ),
      color: const Color(0xFF3C4043),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: _zoomLevels.map((zoom) {
        final isSelected = (_currentZoom - zoom).abs() < 0.01;
        return PopupMenuItem(
          value: zoom,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(zoom * 100).toInt()}%',
                style: TextStyle(
                  color: isSelected ? const Color(0xFF1A73E8) : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isSelected)
                const Icon(Icons.check, color: Color(0xFF1A73E8), size: 16),
            ],
          ),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        _setZoom(value);
      }
    });
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    _pageController.dispose();
    _thumbnailScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF323639),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Memuat PDF...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            )
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _error = null;
                        _isLoading = true;
                      });
                      _initializePdf();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Kembali'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                _buildTopToolbar(),
                Expanded(
                  child: Row(
                    children: [
                      if (_showSidebar) _buildSidebar(),
                      Expanded(
                        child: Container(
                          color: const Color(0xFF525659),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Transform.scale(
                                scale: _currentZoom < 1.0 ? _currentZoom : 1.0,
                                child: SizedBox(
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight,
                                  child: _buildPdfViewer(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPdfViewer() {
    if (_pdfBytes == null) {
      return const Center(
        child: Text(
          'PDF data tidak tersedia',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return SfPdfViewer.memory(
      _pdfBytes!,
      key: ValueKey(widget.assetPath),
      controller: _pdfViewerController,
      enableDoubleTapZooming: true,
      enableTextSelection: true,
      canShowScrollHead: false,
      canShowScrollStatus: false,
      pageLayoutMode:
          PdfPageLayoutMode.single, // Changed from continuous to single
      initialZoomLevel: 1.0,
      onDocumentLoaded: _onDocumentLoaded,
      onPageChanged: _onPageChanged,
      onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
        if (kDebugMode) {
          print('PDF Load Failed - Error: ${details.error}');
          print('PDF Load Failed - Description: ${details.description}');
        }
        setState(() {
          _error =
              'Gagal memuat dokumen PDF\n\n'
              'Error: ${details.error}\n'
              'Detail: ${details.description}\n\n'
              'File: ${widget.assetPath}';
        });
      },
    );
  }

  Widget _buildTopToolbar() {
    return Container(
      height: 56,
      color: const Color(0xFF323639),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: _toggleSidebar,
            tooltip: 'Toggle Sidebar',
          ),
          Expanded(
            child: Text(
              widget.title.replaceAll('.pdf', '').toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF3C4043),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40,
                  child: TextField(
                    controller: _pageController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    onSubmitted: (value) {
                      final page = int.tryParse(value);
                      if (page != null) {
                        _goToPage(page);
                      }
                    },
                  ),
                ),
                Text(
                  ' / $_totalPages',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              Icons.remove,
              color: _currentZoom > _zoomLevels.first
                  ? Colors.white
                  : Colors.white38,
              size: 20,
            ),
            onPressed: _currentZoom > _zoomLevels.first ? _zoomOut : null,
            tooltip: 'Zoom Out',
          ),
          InkWell(
            onTap: _showZoomMenu,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF3C4043),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(_currentZoom * 100).toInt()}%',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white70,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: _currentZoom < _zoomLevels.last
                  ? Colors.white
                  : Colors.white38,
              size: 20,
            ),
            onPressed: _currentZoom < _zoomLevels.last ? _zoomIn : null,
            tooltip: 'Zoom In',
          ),
          Container(
            width: 1,
            height: 24,
            color: Colors.white24,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          IconButton(
            icon: const Icon(Icons.fit_screen, color: Colors.white, size: 20),
            onPressed: _resetZoom,
            tooltip: 'Fit to Page',
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 240,
      color: const Color(0xFF3C4043),
      child: Column(
        children: [
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white12, width: 1),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.list, color: Colors.white70, size: 20),
                SizedBox(width: 8),
                Text(
                  'Thumbnails',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _thumbnailScrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _totalPages,
              itemBuilder: (context, index) {
                final pageNumber = index + 1;
                final isCurrentPage = pageNumber == _currentPage;
                return GestureDetector(
                  onTap: () => _goToPage(pageNumber),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCurrentPage
                          ? const Color(0xFF1A73E8).withOpacity(0.2)
                          : Colors.transparent,
                      border: Border.all(
                        color: isCurrentPage
                            ? const Color(0xFF1A73E8)
                            : Colors.white12,
                        width: isCurrentPage ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.description,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$pageNumber',
                          style: TextStyle(
                            color: isCurrentPage
                                ? const Color(0xFF1A73E8)
                                : Colors.white70,
                            fontSize: 12,
                            fontWeight: isCurrentPage
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
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
