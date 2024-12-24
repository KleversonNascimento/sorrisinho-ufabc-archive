import 'package:sorrisinho_app/tab_bar/model/tab_bar.dart';

class TabBarViewModel {
  final TabBarModel tabBarModel;

  TabBarViewModel({required this.tabBarModel});

  void changeSelectedIndex(int index) => tabBarModel.changeSelectedIndex(index);

  int get selectedIndex => tabBarModel.selectedIndex;
}
