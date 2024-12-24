import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorrisinho_app/other_infos/vacation_countdown/view_model/vacation_countdown.dart';
import 'package:sorrisinho_app/shared/theme.dart';
import 'package:sorrisinho_app/shared/widgets/screen_name.dart';

class VacationCountdownScreen extends StatefulWidget {
  const VacationCountdownScreen({super.key});

  @override
  State<VacationCountdownScreen> createState() =>
      _VacationCountdownScreenState();
}

class _VacationCountdownScreenState extends State<VacationCountdownScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VacationCountdownViewModel>().initialLoad();
  }

  @override
  Widget build(BuildContext context) {
    final timeToVacation =
        context.watch<VacationCountdownViewModel>().timeToVacation;

    return Scaffold(
      backgroundColor: SorrisinhoTheme.primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScreenNameWidget(
              screenName: 'Contador de férias',
              withBackButton: true,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: const Text(
                'Não desanima, as férias começam daqui:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      '${timeToVacation.inDays}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                      ),
                    ),
                    Text(
                      timeToVacation.inDays == 1 ? 'dia' : 'dias',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${23 - DateTime.now().hour}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                      ),
                    ),
                    Text(
                      23 - DateTime.now().hour == 1 ? 'hora' : 'horas',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${59 - DateTime.now().minute}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                      ),
                    ),
                    Text(
                      59 - DateTime.now().minute == 1 ? 'minuto' : 'minutos',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${59 - DateTime.now().second}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                      ),
                    ),
                    Text(
                      59 - DateTime.now().second == 1 ? 'segundo' : 'segundos',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: const Text(
                'Ou seja, ainda dá tempo de...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: const Expanded(
                child: Material(
                  elevation: 0,
                  child: Text('oi'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
