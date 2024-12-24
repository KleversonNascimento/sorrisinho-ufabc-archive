import 'package:sorrisinho_app/other_infos/vacation_countdown/model/vacation_countdown.dart';

class VacationCountdownViewModel {
  final VacationCountdownModel vacationCountdownModel;

  VacationCountdownViewModel({required this.vacationCountdownModel});

  Future<void> initialLoad() async {
    vacationCountdownModel.initialLoad();
  }

  Duration get timeToVacation => vacationCountdownModel.timeToVacation;
}
