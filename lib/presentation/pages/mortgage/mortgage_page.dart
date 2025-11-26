import 'package:dago_valley_explore/presentation/controllers/mortgage/mortgage_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MortgagePage extends StatelessWidget {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Headline')),
      child: Center(child: Text("Mortgage Page")),
    );
  }
}
