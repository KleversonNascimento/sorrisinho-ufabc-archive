import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sorrisinho_app/home/view/widgets/bus_home.dart';
import 'package:sorrisinho_app/home/view/widgets/classroom_home.dart';
import 'package:sorrisinho_app/home/view/widgets/nois_resolve_home.dart';
import 'package:sorrisinho_app/home/view/widgets/restaurant_home.dart';
import 'package:sorrisinho_app/home/view/widgets/the_news_home.dart';
import 'package:sorrisinho_app/home/view_model/home.dart';
import 'package:sorrisinho_app/shared/event_tracker.dart';
import 'package:sorrisinho_app/shared/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    EventTracker().sendEvent(eventName: 'home_page_viewed');
    context.read<HomeViewModel>().initialLoad();
  }

  @override
  Widget build(BuildContext context) {
    final todayClasses = context.watch<HomeViewModel>().remainingTodayClasses;
    final tomorrowClasses = context.watch<HomeViewModel>().tomorrowClasses;
    final todayMenus = context.watch<HomeViewModel>().todayMenus;
    final tomorrowMenus = context.watch<HomeViewModel>().tomorrowMenus;
    final isLoading = context.watch<HomeViewModel>().isLoading;
    final showTheNewsAd = context.watch<HomeViewModel>().showTheNewsAd;
    final noisResolve = context.watch<HomeViewModel>().noisResolve;

    if (isLoading) {
      return Scaffold(
        backgroundColor: SorrisinhoTheme.primaryColor,
        body: SafeArea(
          child: Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: Colors.black,
              size: 50,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: SorrisinhoTheme.primaryColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<HomeViewModel>().refresh();
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Material(
                          elevation: 8,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Atualizado às ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: SorrisinhoTheme.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                todayClasses.isNotEmpty || tomorrowClasses.isNotEmpty
                    ? ClassRoomHomeWidget(
                        todayClasses: todayClasses,
                        tomorrowClasses: tomorrowClasses,
                      )
                    : const SizedBox.shrink(),
                Container(
                  margin: const EdgeInsetsDirectional.only(bottom: 8),
                ),
                showTheNewsAd
                    ? Container(
                        margin: const EdgeInsetsDirectional.only(bottom: 8),
                        child: const TheNewsWidget(),
                      )
                    : const SizedBox.shrink(),
                noisResolve.text.isNotEmpty && noisResolve.link.isNotEmpty
                    ? Container(
                        margin: const EdgeInsetsDirectional.only(bottom: 8),
                        child: NoisResolveWidget(noisResolve: noisResolve),
                      )
                    : const SizedBox.shrink(),
                const BusHomeWidget(),
                Container(
                  margin: const EdgeInsetsDirectional.only(bottom: 8),
                ),
                todayMenus.isNotEmpty || tomorrowMenus.isNotEmpty
                    ? RestaurantHomeWidget(
                        todayMenus: todayMenus,
                        tomorrowMenus: tomorrowMenus,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
