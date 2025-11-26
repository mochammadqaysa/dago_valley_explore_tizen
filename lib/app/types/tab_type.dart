import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabType {
  homepage,
  siteplanpage,
  productpage,
  calculatorpage,
  licenselegaldocumentpage,
  bookingonlinepage,
}

extension TabItem on TabType {
  Icon get icon {
    switch (this) {
      case TabType.homepage:
        return Icon(CupertinoIcons.home, size: 25);
      case TabType.siteplanpage:
        return Icon(CupertinoIcons.map, size: 25);
      case TabType.productpage:
        return Icon(Icons.threesixty, size: 25);
      case TabType.calculatorpage:
        return Icon(CupertinoIcons.money_dollar, size: 25);
      case TabType.licenselegaldocumentpage:
        return Icon(CupertinoIcons.doc_text, size: 25);
      case TabType.bookingonlinepage:
        return Icon(CupertinoIcons.book, size: 25);
    }
  }

  String get title {
    switch (this) {
      case TabType.homepage:
        return "Dashboard";
      case TabType.siteplanpage:
        return "Site Plan Interaktif";
      case TabType.productpage:
        return "Virtual Tour";
      case TabType.calculatorpage:
        return "Simulasi KPR";
      case TabType.licenselegaldocumentpage:
        return "Dokumen Perizinan & Legalitas";
      case TabType.bookingonlinepage:
        return "Booking Online";
    }
  }

  String get svgIcon {
    switch (this) {
      case TabType.homepage:
        return "assets/menu/home_icon.svg";
      case TabType.siteplanpage:
        return "assets/menu/siteplan_icon.svg";
      case TabType.productpage:
        return "assets/menu/product_icon.svg";
      case TabType.calculatorpage:
        return "assets/menu/calculator_icon.svg";
      case TabType.licenselegaldocumentpage:
        return "assets/menu/folder_icon.svg";
      case TabType.bookingonlinepage:
        return "assets/menu/hotline_icon.svg";
    }
  }
}
