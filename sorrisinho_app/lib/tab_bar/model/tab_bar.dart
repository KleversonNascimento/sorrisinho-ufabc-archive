import 'package:flutter/cupertino.dart';

class TabBarModel extends ChangeNotifier {
  int selectedIndex = 0;

  void changeSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
