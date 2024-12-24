import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sorrisinho_app/classroom/models/discipline.dart';
import 'package:sorrisinho_app/classroom/view_model/classroom.dart';
import 'package:sorrisinho_app/shared/event_tracker.dart';
import 'package:sorrisinho_app/shared/theme.dart';
import 'package:sorrisinho_app/shared/widgets/screen_name.dart';

class EditClassRoomsScreen extends StatefulWidget {
  const EditClassRoomsScreen({super.key});

  @override
  State<EditClassRoomsScreen> createState() => _EditClassRoomsScreenState();
}

class _EditClassRoomsScreenState extends State<EditClassRoomsScreen> {
  late TextEditingController _filterDisciplinesController;

  @override
  void initState() {
    super.initState();
    _filterDisciplinesController = TextEditingController();

    _filterDisciplinesController.addListener(() {
      context
          .read<ClassRoomViewModel>()
          .filterAllAvailableDisciplines(_filterDisciplinesController.text);
    });

    context.read<ClassRoomViewModel>().fetchAllDisciplines();
  }

  @override
  Widget build(BuildContext context) {
    final allMyDisciplines =
        context.watch<ClassRoomViewModel>().allMyDisciplines;
    final isLoading = context.watch<ClassRoomViewModel>().isLoading;
    var allAvailableDisciplines =
        context.watch<ClassRoomViewModel>().allAvailableDisciplines;
    allAvailableDisciplines
        .removeWhere((discipline) => allMyDisciplines.contains(discipline));

    if (allAvailableDisciplines.length > 50) {
      allAvailableDisciplines = allAvailableDisciplines.sublist(0, 50);
    }

    if (isLoading ||
        (allAvailableDisciplines.isEmpty &&
            _filterDisciplinesController.text.isEmpty)) {
      return Scaffold(
        backgroundColor: SorrisinhoTheme.primaryColor,
        body: SafeArea(
          child: Column(
            children: [
              const ScreenNameWidget(
                screenName: 'Editar aulas',
                withBackButton: true,
              ),
              Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.black,
                  size: 50,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: SorrisinhoTheme.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenNameWidget(
                screenName: 'Editar aulas',
                withBackButton: true,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  children: const [
                    Text(
                      'Minhas aulas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              ...allMyDisciplines
                  .map(
                    (discipline) =>
                        DisciplineToRemoveWidget(discipline: discipline),
                  )
                  .toList(),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  children: const [
                    Text(
                      'Todas as aulas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                child: TextField(
                  controller: _filterDisciplinesController,
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    helperStyle: TextStyle(color: Colors.white),
                    hintText: 'Pesquisar pelo nome da aula',
                  ),
                ),
              ),
              ...allAvailableDisciplines
                  .map(
                    (discipline) =>
                        DisciplineToAddWidget(discipline: discipline),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class DisciplineToRemoveWidget extends StatelessWidget {
  final Discipline discipline;

  const DisciplineToRemoveWidget({super.key, required this.discipline});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Material(
        elevation: 8,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
            ),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (BuildContext builcContext) {
                  return ConfirmRemoveDisciplineWidget(
                    discipline: discipline,
                  );
                },
              ),
              child: const Text(
                'Remover',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 12),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${discipline.name} - ${discipline.classCode}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      discipline.campus,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      discipline.code,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
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
}

class ConfirmRemoveDisciplineWidget extends StatelessWidget {
  final Discipline discipline;
  const ConfirmRemoveDisciplineWidget({super.key, required this.discipline});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  'Remover aula',
                  style: TextStyle(
                    color: SorrisinhoTheme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: const Text(
                  'Tem certeza que deseja remover essa aula?',
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
                            eventName: 'cancel_remove_discipline_clicked',
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: SorrisinhoTheme.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        EventTracker().sendEvent(
                          eventName: 'remove_discipline_clicked',
                        );
                        context
                            .read<ClassRoomViewModel>()
                            .removeDiscipline(discipline);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ),
                      ),
                      child: const Text(
                        'Remover',
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
  }
}

class DisciplineToAddWidget extends StatelessWidget {
  final Discipline discipline;

  const DisciplineToAddWidget({super.key, required this.discipline});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Material(
        elevation: 8,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
            ),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (BuildContext builcContext) {
                  return ConfirmAddDisciplineWidget(
                    discipline: discipline,
                  );
                },
              ),
              child: Text(
                'Adicionar',
                style: TextStyle(
                  color: SorrisinhoTheme.informationBackgroundColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 12),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${discipline.name} - ${discipline.classCode}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      discipline.campus,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      discipline.code,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
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
}

class ConfirmAddDisciplineWidget extends StatelessWidget {
  final Discipline discipline;
  const ConfirmAddDisciplineWidget({super.key, required this.discipline});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  'Adicionar aula',
                  style: TextStyle(
                    color: SorrisinhoTheme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: const Text(
                  'Tem certeza que deseja adicionar essa aula?',
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
                            eventName: 'cancel_add_discipline_clicked',
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: SorrisinhoTheme.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        EventTracker().sendEvent(
                          eventName: 'add_discipline_clicked',
                        );
                        context
                            .read<ClassRoomViewModel>()
                            .addDiscipline(discipline);
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ),
                      ),
                      child: const Text(
                        'Adicionar',
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
  }
}
