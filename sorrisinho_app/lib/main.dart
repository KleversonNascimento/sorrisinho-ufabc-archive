import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorrisinho_app/bus/model/bus.dart';
import 'package:sorrisinho_app/calendar/model/calendar.dart';
import 'package:sorrisinho_app/calendar/view_model/calendar.dart';
import 'package:sorrisinho_app/classroom/model/classroom.dart';
import 'package:sorrisinho_app/classroom/view_model/classroom.dart';
import 'package:sorrisinho_app/home/view_model/home.dart';
import 'package:sorrisinho_app/other_infos/vacation_countdown/model/vacation_countdown.dart';
import 'package:sorrisinho_app/other_infos/vacation_countdown/view_model/vacation_countdown.dart';
import 'package:sorrisinho_app/restaurant/model/restaurant.dart';
import 'package:sorrisinho_app/restaurant/view_model/restaurant.dart';
import 'package:sorrisinho_app/shared/theme.dart';
import 'package:sorrisinho_app/tab_bar/model/tab_bar.dart';
import 'package:sorrisinho_app/tab_bar/view/screens/tab_bar.dart';
import 'package:sorrisinho_app/tab_bar/view_model/tab_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TabBarModel(),
        ),
        ProxyProvider<TabBarModel, TabBarViewModel>(
          create: (context) => TabBarViewModel(
            tabBarModel: context.read<TabBarModel>(),
          ),
          update: (context, model, notifier) => TabBarViewModel(
            tabBarModel: model,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CalendarModel(),
        ),
        ProxyProvider<CalendarModel, CalendarViewModel>(
          create: (context) => CalendarViewModel(
            calendarModel: context.read<CalendarModel>(),
          ),
          update: (context, model, notifier) => CalendarViewModel(
            calendarModel: model,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantModel(),
        ),
        ProxyProvider<RestaurantModel, RestaurantViewModel>(
          create: (context) => RestaurantViewModel(
            restaurantModel: context.read<RestaurantModel>(),
          ),
          update: (context, model, notifier) => RestaurantViewModel(
            restaurantModel: model,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ClassRoomModel(),
        ),
        ProxyProvider<ClassRoomModel, ClassRoomViewModel>(
          create: (context) => ClassRoomViewModel(
            classRoomModel: context.read<ClassRoomModel>(),
          ),
          update: (context, model, notifier) => ClassRoomViewModel(
            classRoomModel: model,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => VacationCountdownModel(),
        ),
        ProxyProvider<VacationCountdownModel, VacationCountdownViewModel>(
          create: (context) => VacationCountdownViewModel(
            vacationCountdownModel: context.read<VacationCountdownModel>(),
          ),
          update: (context, model, notifier) => VacationCountdownViewModel(
            vacationCountdownModel: model,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => BusModel(),
        ),
        ProxyProvider4<ClassRoomModel, BusModel, RestaurantModel, TabBarModel,
            HomeViewModel>(
          create: (context) => HomeViewModel(
            classRoomModel: context.read<ClassRoomModel>(),
            busModel: context.read<BusModel>(),
            restaurantModel: context.read<RestaurantModel>(),
            tabBarModel: context.read<TabBarModel>(),
          ),
          update: (context, classRoomModel, busModel, restaurantModel,
                  tabBarModel, notifier) =>
              HomeViewModel(
            classRoomModel: classRoomModel,
            busModel: busModel,
            restaurantModel: restaurantModel,
            tabBarModel: tabBarModel,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Sorrisinho',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'NotoSans',
          primarySwatch: SorrisinhoTheme.getMaterialColor(),
        ),
        home: const TabBarScreen(),
      ),
    );
  }
}
