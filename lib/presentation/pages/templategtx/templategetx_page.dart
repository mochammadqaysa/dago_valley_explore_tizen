import 'package:dago_valley_explore/presentation/controllers/dashboard/dashboard_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/virtualtour/virtualtour_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../detail/detail_page.dart';

class VirtualtourPage extends GetView<VirtualtourController> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: controller,
      initState: (state) {
        controller.fetchData();
      },
      didUpdateWidget: (old, newState) {
        _scrollController.addListener(_scrollListener);
      },
      dispose: (state) {
        _scrollController.removeListener(_scrollListener);
      },
      builder: (_) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(middle: Text('Headline')),
          child: Text("Virtual Tour"),
          // child: ListView.builder(
          //   controller: _scrollController,
          //   itemCount: controller.articles.length,
          //   itemBuilder: (context, index) {
          //     final article = controller.articles[index];
          //     return GestureDetector(
          //       onTap: () {
          //         Get.to(() => DetailPage(article: article));
          //       },
          //       child: ArticleCell(article: article),
          //     );
          //   },
          // ),
        );
      },
    );
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 500) {
      print("load more");
      controller.loadMore();
    }
  }
}
