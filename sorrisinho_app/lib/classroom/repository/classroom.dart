import 'dart:convert';

import 'package:http/http.dart';
import 'package:sorrisinho_app/classroom/models/classroom.dart';
import 'package:sorrisinho_app/classroom/models/discipline.dart';
import 'package:sorrisinho_app/classroom/models/nois_resolve.dart';
import 'package:sorrisinho_app/shared/urls.dart';

class ClassRoomRepository {
  Future<List<ClassRoom>> fetchAllMyClasses(
    int ra,
    List<int> addedDisciplines,
  ) async {
    final response = await post(
      Uri.parse(Urls.allMyClasses(ra)),
      body: addedDisciplines.toString(),
      headers: Map.from(
        {'Content-Type': 'application/json'},
      ),
    );

    final unformmatedClasses =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

    final formmatedClasses = unformmatedClasses
        .map((classrooom) => ClassRoom.fromJson(classrooom))
        .toList();

    return formmatedClasses;
  }

  Future<NoisResolve> fetchNoisResolve(
    int ra,
    List<int> addedDisciplines,
  ) async {
    final response = await post(
      Uri.parse(Urls.noisResolve(ra)),
      body: addedDisciplines.toString(),
      headers: Map.from(
        {'Content-Type': 'application/json'},
      ),
    );

    return NoisResolve.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  Future<List<Discipline>> fetchAllDisciplines() async {
    final response = await get(Uri.parse(Urls.allDisciplines));

    final unformmatedDisciplines =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

    final formmatedDisciplines = unformmatedDisciplines
        .map((discipline) => Discipline.fromJson(discipline))
        .toList();

    formmatedDisciplines.sort((a, b) => a.name.compareTo(b.name));

    return formmatedDisciplines;
  }

  Future<bool> makeEnrollments(int ra, String sigaaText) async {
    try {
      await post(Uri.parse(Urls.insertSigaaText(ra)), body: sigaaText);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> theNews() async {
    try {
      final response = await get(Uri.parse(Urls.theNews));
      return response.body == 'true' ? true : false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteCustomEnrollments(int ra) async {
    try {
      await get(Uri.parse(Urls.deleteCustomEnrollments(ra)));
      return true;
    } catch (_) {
      return false;
    }
  }
}
