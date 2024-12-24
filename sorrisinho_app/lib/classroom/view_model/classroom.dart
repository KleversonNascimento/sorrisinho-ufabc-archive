import 'package:sorrisinho_app/classroom/model/classroom.dart';
import 'package:sorrisinho_app/classroom/models/classroom.dart';
import 'package:sorrisinho_app/classroom/models/discipline.dart';

class ClassRoomViewModel {
  final ClassRoomModel classRoomModel;

  ClassRoomViewModel({required this.classRoomModel});

  Future<void> initialLoad() async {
    classRoomModel.initialLoad();
  }

  Map<int, List<ClassRoom>> get weekClasses => classRoomModel.weekClasses;

  Map<int, List<ClassRoom>> get allClassesWeeklyOne =>
      classRoomModel.allClassesWeeklyOne;

  Map<int, List<ClassRoom>> get allClassesWeeklyTwo =>
      classRoomModel.allClassesWeeklyTwo;

  List<ClassRoom> get todayClasses => classRoomModel.todayClasses;

  List<Discipline> get allMyDisciplines => classRoomModel.allMyDisciplines;

  void removeDiscipline(Discipline discipline) =>
      classRoomModel.removeDiscipline(discipline);

  void addDiscipline(Discipline discipline) =>
      classRoomModel.addDiscipline(discipline);

  Future<void> fetchAllDisciplines() => classRoomModel.fetchAllDisciplines();

  List<Discipline> get allAvailableDisciplines =>
      classRoomModel.filteredAllAvailableDisciplines;

  void filterAllAvailableDisciplines(String text) =>
      classRoomModel.filterAllAvailableDisciplines(text);

  bool get isLoading => classRoomModel.isLoading;

  bool get isRaFilled => classRoomModel.isRaFilled;

  Future<bool> saveRa(String ra) => classRoomModel.saveRa(ra);

  Future<bool> insertSigaaText(String ra, String sigaaText) =>
      classRoomModel.insertSigaaText(ra, sigaaText);

  Future<void> deleteRa() => classRoomModel.deleteRa();
}
