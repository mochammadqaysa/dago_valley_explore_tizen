import 'dart:convert';
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

  Map<String, List<Map<String, String>>> pdfFiles = {
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

    _mainTabController.addListener(() {
      if (_mainTabController.indexIsChanging) {
        setState(() {});
      }
    });

    loadPdfList();
  }

  void _showQRCodeModal([String? url]) {
    if (url == null || url.isEmpty) {
      try {
        final storage = Get.find<LocalStorageService>();
        final brochures = storage.brochures;
        if (brochures != null && brochures.isNotEmpty) {
          final first = brochures.first;
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

      final tahap1Legalitas = manifestMap.keys
          .where(
            (String key) =>
                key.startsWith('assets/tahap_1/legalitas/') &&
                key.endsWith('.pdf'),
          )
          .toList();

      final tahap1Perizinan = manifestMap.keys
          .where(
            (String key) =>
                key.startsWith('assets/tahap_1/perizinan/') &&
                key.endsWith('.pdf'),
          )
          .toList();

      final tahap2Legalitas = manifestMap.keys
          .where(
            (String key) =>
                key.startsWith('assets/tahap_2/legalitas/') &&
                key.endsWith('.pdf'),
          )
          .toList();

      final tahap2Perizinan = manifestMap.keys
          .where(
            (String key) =>
                key.startsWith('assets/tahap_2/perizinan/') &&
                key.endsWith('.pdf'),
          )
          .toList();

      setState(() {
        pdfFiles['tahap_1_legalitas'] = tahap1Legalitas
            .map((path) => {'name': path.split('/').last, 'path': path})
            .toList();
        pdfFiles['tahap_1_perizinan'] = tahap1Perizinan
            .map((path) => {'name': path.split('/').last, 'path': path})
            .toList();
        pdfFiles['tahap_2_legalitas'] = tahap2Legalitas
            .map((path) => {'name': path.split('/').last, 'path': path})
            .toList();
        pdfFiles['tahap_2_perizinan'] = tahap2Perizinan
            .map((path) => {'name': path.split('/').last, 'path': path})
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

  Future<void> openPdf(String fileName, String title, String assetPath) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(assetPath: assetPath, title: title),
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
          onPressed: () => _showQRCodeModal(),
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
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      children: [
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
                  Expanded(
                    child: TabBarView(
                      controller: _mainTabController,
                      children: [
                        _buildTahapContent(
                          isDarkMode,
                          isTV,
                          _tahap1TabController,
                          'tahap_1',
                        ),
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
        _buildPdfGrid(isDarkMode, isTV, pdfFiles['${tahap}_legalitas']!),
        _buildPdfGrid(isDarkMode, isTV, pdfFiles['${tahap}_perizinan']!),
      ],
    );
  }

  Widget _buildPdfGrid(
    bool isDarkMode,
    bool isTV,
    List<Map<String, String>> files,
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
        final file = files[index];
        final fileName = file['name']!;
        final filePath = file['path']!;

        return GestureDetector(
          onTap: () => openPdf(fileName, fileName, filePath),
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
                      fontSize: isTV ? 12 : 16,
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

// Syncfusion PDF Viewer Page
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
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  int _currentPage = 1;
  int _totalPages = 0;

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF525659),
      appBar: AppBar(
        backgroundColor: const Color(0xFF323639),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title.replaceAll('.pdf', '').toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_out, color: Colors.white),
            onPressed: () {
              _pdfViewerController.zoomLevel =
                  (_pdfViewerController.zoomLevel - 0.25).clamp(0.5, 3.0);
            },
            tooltip: 'Zoom Out',
          ),
          Center(
            child: Text(
              '${(_pdfViewerController.zoomLevel * 100).toInt()}%',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in, color: Colors.white),
            onPressed: () {
              _pdfViewerController.zoomLevel =
                  (_pdfViewerController.zoomLevel + 0.25).clamp(0.5, 3.0);
            },
            tooltip: 'Zoom In',
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: _currentPage > 1
                ? () => _pdfViewerController.previousPage()
                : null,
            tooltip: 'Previous Page',
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            child: Text(
              '$_currentPage / $_totalPages',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: _currentPage < _totalPages
                ? () => _pdfViewerController.nextPage()
                : null,
            tooltip: 'Next Page',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SfPdfViewer.asset(
        widget.assetPath,
        key: _pdfViewerKey,
        controller: _pdfViewerController,
        canShowScrollHead: false,
        canShowScrollStatus: false,
        enableDoubleTapZooming: true,
        enableTextSelection: true,
        pageLayoutMode: PdfPageLayoutMode.continuous,
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
          setState(() {
            _totalPages = details.document.pages.count;
          });
        },
        onPageChanged: (PdfPageChangedDetails details) {
          setState(() {
            _currentPage = details.newPageNumber;
          });
        },
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          if (kDebugMode) {
            print('PDF Load Failed: ${details.error}');
            print('Description: ${details.description}');
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load PDF: ${details.description}'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Close',
                textColor: Colors.white,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          );
        },
      ),
    );
  }
}
