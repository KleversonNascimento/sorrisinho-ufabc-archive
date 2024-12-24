import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorrisinho_app/calendar/view/screens/calendar.dart';
import 'package:sorrisinho_app/classroom/view/screens/classrooms.dart';
import 'package:sorrisinho_app/home/view/screens/home.dart';
import 'package:sorrisinho_app/shared/event_tracker.dart';
import 'package:sorrisinho_app/shared/theme.dart';
import 'package:sorrisinho_app/tab_bar/view_model/tab_bar.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  @override
  void initState() {
    super.initState();
    EventTracker().init();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ClassRoomScreen(),
    CalendarScreen(),
  ];

  void _onItemTapped(int index) {
    EventTracker().sendEvent(eventName: 'tab_bar_item_${index}_clicked');
    context.read<TabBarViewModel>().changeSelectedIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.watch<TabBarViewModel>().selectedIndex;

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Aulas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Calendário',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: SorrisinhoTheme.primaryColor,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        enableFeedback: true,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
