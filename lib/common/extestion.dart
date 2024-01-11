import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl; 

extension PaddingExtesion on Widget {
  Padding paddingLR(double left, double right) {
    return Padding(
      padding: EdgeInsets.only(left: left, right: right),
      child: this,
    );
  }

  Padding paddingTB(double top, double bottom) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: bottom),
      child: this,
    );
  }
}

extension ContextExtesion on BuildContext {
  TextTheme get themedata => Theme.of(this).textTheme;

  Future<Object?> nav(Widget w,{bool navroot=false}) {
    return Navigator.of(this,rootNavigator: navroot).push(MaterialPageRoute(
        builder: (_) =>
            Directionality(textDirection: TextDirection.rtl, child: w)));
  }
}

extension PriceLabale on int {
  String get withPriceLabale =>this>0? '$sepratedByComma تومان':"رایگان";

  String get sepratedByComma {
    final numberFormat = intl.NumberFormat.decimalPattern();
    return numberFormat.format(this);

  }
}
