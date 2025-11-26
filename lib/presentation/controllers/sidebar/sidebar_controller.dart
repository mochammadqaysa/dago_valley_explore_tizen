import 'package:dago_valley_explore/app/types/tab_type.dart';
import 'package:get/get.dart';

class SidebarController extends GetxController {
  // Observable untuk collapse state
  final _isCollapsed = false.obs;
  bool get isCollapsed => _isCollapsed.value;

  // Observable untuk tab yang aktif
  final _activeTab = TabType.homepage.obs;
  TabType get activeTab => _activeTab.value;

  @override
  void onInit() {
    super.onInit();
    print('SidebarController initialized');
  }

  @override
  void onClose() {
    print('SidebarController disposed');
    super.onClose();
  }

  // Toggle collapse drawer
  void toggleCollapse() {
    _isCollapsed.value = !_isCollapsed.value;
  }

  // Set active tab
  void setActiveTab(TabType tab) {
    print('Setting active tab: $tab');
    _activeTab.value = tab;
  }

  // Check apakah tab aktif
  bool isTabActive(TabType tab) {
    return _activeTab.value == tab;
  }
}
