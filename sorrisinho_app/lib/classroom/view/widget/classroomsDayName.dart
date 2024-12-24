import 'package:flutter/material.dart';
import 'package:sorrisinho_app/classroom/models/classroom.dart';
import 'package:sorrisinho_app/classroom/view/widget/class.dart';
import 'package:sorrisinho_app/shared/calendar_functions.dart';

class ClassRoomDayWidget extends StatelessWidget {
  final List<ClassRoom> classRooms;

  const ClassRoomDayWidget({
    super.key,
    required this.classRooms,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
          child: Text(
            getWeekdayNameFromNumber(classRooms.first.weekDayNumber),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        ...classRooms
            .map((classRoom) => ClassRoomWidget(classRoom: classRoom))
            .toList()
      ],
    );
  }
}
