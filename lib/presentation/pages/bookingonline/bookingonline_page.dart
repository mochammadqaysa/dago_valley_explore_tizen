import 'package:dago_valley_explore/presentation/controllers/bookingonline/bookingonline_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/dashboard/dashboard_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../detail/detail_page.dart';

class BookingonlinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Headline')),
      child: Text("Booking Online"),
    );
  }
}
