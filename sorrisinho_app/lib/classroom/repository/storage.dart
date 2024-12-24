import 'package:shared_preferences/shared_preferences.dart';

class ClassRoomStorage {
  final _raKey = 'student_ra';
  final _classroomsKey = 'student_classrooms';
  final _removedDisciplinesKey = 'student_removed_disciplines';
  final _addedDisciplinesKey = 'student_added_disciplines';

  Future<void> setRa(String ra) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString(_raKey, ra);
  }

  Future<String> getRa() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString(_raKey) ?? '';
  }

  Future<void> setClassrooms(String classroooms) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString(_classroomsKey, classroooms);
  }

  Future<String> getClassrooms() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString(_classroomsKey) ?? '';
  }

  Future<void> setRemovedDisciplines(String removedDisciplines) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString(_removedDisciplinesKey, removedDisciplines);
  }

  Future<String> getRemovedDisciplines() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString(_removedDisciplinesKey) ?? '';
  }

  Future<void> setAddedDisciplines(String addedDisciplines) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString(_addedDisciplinesKey, addedDisciplines);
  }

  Future<String> getAddedDisciplines() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString(_addedDisciplinesKey) ?? '';
  }
}
