import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sorrisinho_app/classroom/view/screens/edit_classrooms.dart';
import 'package:sorrisinho_app/classroom/view/screens/insert_sigaa_text.dart';
import 'package:sorrisinho_app/classroom/view/widget/classroomsDayName.dart';
import 'package:sorrisinho_app/classroom/view_model/classroom.dart';
import 'package:sorrisinho_app/shared/calendar_functions.dart';
import 'package:sorrisinho_app/shared/current_biweekly_enum.dart';
import 'package:sorrisinho_app/shared/event_tracker.dart';
import 'package:sorrisinho_app/shared/theme.dart';
import 'package:sorrisinho_app/shared/widgets/screen_name.dart';

class ClassRoomScreen extends StatefulWidget {
  const ClassRoomScreen({super.key});

  @override
  State<ClassRoomScreen> createState() => _ClassRoomScreenState();
}

class _ClassRoomScreenState extends State<ClassRoomScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late TextEditingController _raTextFieldController;

  @override
  void initState() {
    super.initState();
    EventTracker().sendEvent(eventName: 'classroom_page_viewed');
    final isBiweeklyTwo = findCurrentBiweekly() == CurrentBiweekly.two;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: isBiweeklyTwo ? 1 : 0,
    );
    _raTextFieldController = TextEditingController();
    context.read<ClassRoomViewModel>().initialLoad();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allClassesWeeklyOne =
        context.watch<ClassRoomViewModel>().allClassesWeeklyOne;
    final allClassesWeeklyTwo =
        context.watch<ClassRoomViewModel>().allClassesWeeklyTwo;
    final isLoading = context.watch<ClassRoomViewModel>().isLoading;
    final isRaFilled = context.watch<ClassRoomViewModel>().isRaFilled;

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

    if (!isRaFilled) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: SorrisinhoTheme.primaryColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenNameWidget(
                screenName: 'Aulas',
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: const [
                          Text(
                            'Preencha seu RA para carregar suas aulas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                      ),
                      TextField(
                        controller: _raTextFieldController,
                        keyboardType: TextInputType.number,
                        maxLength: 11,
                        maxLines: 1,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          helperStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            EventTracker().sendEvent(
                              eventName: 'insert_ra_clicked',
                              eventProps: {'ra': _raTextFieldController.text},
                            );
                            final needsInsertSigaaText = await context
                                .read<ClassRoomViewModel>()
                                .saveRa(_raTextFieldController.text);
                            if (needsInsertSigaaText && context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InsertSigaaTextScreen(
                                    previousRa: _raTextFieldController.text,
                                  ),
                                ),
                              );
                            } else {
                              _raTextFieldController.text = '';
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 8,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.zero),
                            ),
                          ),
                          child: Text(
                            'Enviar',
                            style: TextStyle(
                              color: SorrisinhoTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        backgroundColor: SorrisinhoTheme.primaryColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenNameWidget(
                screenName: 'Aulas',
                leftIcon: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditClassRoomsScreen(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
                rightIcon: GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (BuildContext builcContext) {
                      return Wrap(
                        children: [
                          SafeArea(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 4),
                                  child: Text(
                                    'Excluir RA e aulas',
                                    style: TextStyle(
                                      color: SorrisinhoTheme.primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 4),
                                  child: const Text(
                                    'Tem certeza que deseja excluir seu RA e todas as suas aulas?',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(
                                    16,
                                    4,
                                    16,
                                    0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            EventTracker().sendEvent(
                                              eventName:
                                                  'cancel_delete_aulas_clicked',
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Cancelar',
                                            style: TextStyle(
                                              color:
                                                  SorrisinhoTheme.primaryColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          EventTracker().sendEvent(
                                            eventName:
                                                'confirm_delete_ra_clicked',
                                          );
                                          context
                                              .read<ClassRoomViewModel>()
                                              .deleteRa();
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.all(Radius.zero),
                                          ),
                                        ),
                                        child: const Text(
                                          'Excluir',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: SorrisinhoTheme.informationBackgroundColor,
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                      child: Text(
                        'Semana ${findCurrentBiweekly() == CurrentBiweekly.one ? 'Quinzenal I' : 'Quinzenal II'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...<Widget>[
                TabBar(
                  controller: _tabController,
                  tabs: const <Widget>[
                    Tab(text: 'Quinzenal I'),
                    Tab(text: 'Quinzenal II'),
                  ],
                  onTap: (value) {
                    EventTracker()
                        .sendEvent(eventName: 'classroom_tab_${value}_clicked');
                  },
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...allClassesWeeklyOne.values
                                .map(
                                  (classRooms) => ClassRoomDayWidget(
                                    classRooms: classRooms,
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...allClassesWeeklyTwo.values
                                .map(
                                  (classRooms) => ClassRoomDayWidget(
                                    classRooms: classRooms,
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
