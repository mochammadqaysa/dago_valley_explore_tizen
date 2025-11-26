import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../domain/entities/article.dart';
import '../../../domain/entities/paging.dart';
import '../../../domain/usecases/fetch_headline_use_case.dart';
import 'package:tuple/tuple.dart';

class DashboardController extends GetxController {
  DashboardController(this._fetchHeadlineUseCase);
  final FetchHeadlineUseCase _fetchHeadlineUseCase;
  int _currentPage = 1;
  int _pageSize = 20;
  var _isLoadMore = false;
  var _paging = Rx<Paging?>(null);

  final LocalStorageService _storage = Get.find<LocalStorageService>();
  var articles = RxList<Article>([]);

  String get welcomeText {
    return _storage.housings?.welcomeText ?? "welcome_desc".tr;
  }

  String get welcomeTextEn {
    return _storage.housings?.welcomeTextEn ?? "welcome_desc".tr;
  }

  fetchData() async {
    final newPaging = await _fetchHeadlineUseCase.execute(
      Tuple2(_currentPage, _pageSize),
    );
    articles.assignAll(newPaging.articles);
    _paging.value = newPaging;
  }

  loadMore() async {
    final totalResults = _paging.value?.totalResults ?? 0;
    if (totalResults / _pageSize <= _currentPage) return;
    if (_isLoadMore) return;
    _isLoadMore = true;
    _currentPage += 1;
    final newPaging = await _fetchHeadlineUseCase.execute(
      Tuple2(_currentPage, _pageSize),
    );
    articles.addAll(newPaging.articles);
    _paging.value?.totalResults = newPaging.totalResults;
    _isLoadMore = false;
  }
}
