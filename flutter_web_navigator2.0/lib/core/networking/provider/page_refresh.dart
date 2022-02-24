import 'package:flutter/material.dart';

class PageRefresh extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}
