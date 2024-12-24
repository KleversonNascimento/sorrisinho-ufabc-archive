import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorrisinho_app/bus/models/bus_trip.dart';
import 'package:sorrisinho_app/home/view_model/home.dart';
import 'package:sorrisinho_app/shared/calendar_functions.dart';
import 'package:sorrisinho_app/shared/theme.dart';

class BusHomeWidget extends StatefulWidget {
  const BusHomeWidget({super.key});

  @override
  State<BusHomeWidget> createState() => _BusHomeWidgetState();
}

class _BusHomeWidgetState extends State<BusHomeWidget> {
  int _selectedDay = 0;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableArrivals = context.watch<HomeViewModel>().availableArrivals;
    final availableDepartures =
        context.watch<HomeViewModel>().availableDepartures;
    final selectedArrival = context.watch<HomeViewModel>().selectedArrival;
    final selectedDeparture = context.watch<HomeViewModel>().selectedDeparture;
    final availableBusTrips = context.watch<HomeViewModel>().selectedBusTrips;
    final selectedDate = context.watch<HomeViewModel>().selectedDateForBusTrips;
    final lastBusTrip = context.watch<HomeViewModel>().lastBusTrip;
    final availableDates = [
      'Hoje',
      'Segunda à sexta',
      'Sábado',
    ];

    return Container(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: Material(
        elevation: 8,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
              width: MediaQuery.of(context).size.width - 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Fretado - ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 26,
                        onPressed: () => _showDialog(
                          CupertinoPicker(
                            magnification: 1.22,
                            squeeze: 1.2,
                            useMagnifier: true,
                            itemExtent: 32.0,
                            scrollController: FixedExtentScrollController(
                              initialItem: _selectedDay,
                            ),
                            onSelectedItemChanged: (int selectedItem) {
                              context.read<HomeViewModel>().changeSelectedDate(
                                    randomTimeByNumber[selectedItem]!,
                                  );
                              setState(() {
                                _selectedDay = selectedItem;
                              });
                            },
                            children: List<Widget>.generate(
                                availableDates.length, (int index) {
                              return Center(
                                child: Text(availableDates[index]),
                              );
                            }),
                          ),
                        ),
                        child: Text(
                          isToday(selectedDate)
                              ? 'hoje'
                              : getTitle(selectedDate),
                          style: TextStyle(
                            fontSize: 20,
                            color: SorrisinhoTheme.informationBackgroundColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'De: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 26,
                        onPressed: () => _showDialog(
                          CupertinoPicker(
                            magnification: 1.22,
                            squeeze: 1.2,
                            useMagnifier: true,
                            itemExtent: 32.0,
                            scrollController: FixedExtentScrollController(
                              initialItem: availableDepartures.indexWhere(
                                (departure) => departure == selectedDeparture,
                              ),
                            ),
                            onSelectedItemChanged: (int selectedItem) {
                              context.read<HomeViewModel>().changDeparture(
                                    availableDepartures[selectedItem],
                                  );
                            },
                            children: List<Widget>.generate(
                                availableDepartures.length, (int index) {
                              return Center(
                                child: Text(availableDepartures[index]),
                              );
                            }),
                          ),
                        ),
                        child: Text(
                          selectedDeparture,
                          style: TextStyle(
                            fontSize: 16,
                            color: SorrisinhoTheme.informationBackgroundColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Para: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 26,
                        onPressed: () => _showDialog(
                          CupertinoPicker(
                            magnification: 1.22,
                            squeeze: 1.2,
                            useMagnifier: true,
                            itemExtent: 32.0,
                            scrollController: FixedExtentScrollController(
                              initialItem: availableArrivals.indexWhere(
                                (arrival) => arrival == selectedArrival,
                              ),
                            ),
                            onSelectedItemChanged: (int selectedItem) {
                              context.read<HomeViewModel>().changeArrival(
                                    availableArrivals[selectedItem],
                                  );
                            },
                            children: List<Widget>.generate(
                                availableArrivals.length, (int index) {
                              return Center(
                                child: Text(availableArrivals[index]),
                              );
                            }),
                          ),
                        ),
                        child: Text(
                          selectedArrival,
                          style: TextStyle(
                            fontSize: 16,
                            color: SorrisinhoTheme.informationBackgroundColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 0),
                  ),
                  lastBusTrip != null
                      ? LastBusTrip(
                          busTrip: lastBusTrip,
                          selectedDate: selectedDate,
                        )
                      : const SizedBox.shrink(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...availableBusTrips
                            .map(
                              (item) => BusTripWidget(
                                busTrip: item,
                                selectedDate: selectedDate,
                              ),
                            )
                            .toList()
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsetsDirectional.only(bottom: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LastBusTrip extends StatelessWidget {
  final BusTrip busTrip;
  final DateTime selectedDate;

  const LastBusTrip({
    super.key,
    required this.busTrip,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 4),
            alignment: Alignment.center,
            child: Text(
              (Duration(
                            hours: selectedDate.hour,
                            minutes: selectedDate.minute,
                          ).inMinutes -
                          busTrip.departureTime.inMinutes <
                      60)
                  ? (Duration(
                                hours: selectedDate.hour,
                                minutes: selectedDate.minute,
                              ).inMinutes -
                              busTrip.departureTime.inMinutes <=
                          1)
                      ? 'O ultimo fretado foi da linha ${busTrip.lineNumber} há ${Duration(
                            hours: selectedDate.hour,
                            minutes: selectedDate.minute,
                          ).inMinutes - busTrip.departureTime.inMinutes} minuto'
                      : 'O ultimo fretado foi da linha ${busTrip.lineNumber} há ${Duration(
                            hours: selectedDate.hour,
                            minutes: selectedDate.minute,
                          ).inMinutes - busTrip.departureTime.inMinutes} minutos'
                  : 'O ultimo fretado foi da linha ${busTrip.lineNumber} às ${busTrip.departureTime.inHours.toString().padLeft(2, '0')}:${busTrip.departureTime.inMinutes.remainder(60).toString().padLeft(2, '0')}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BusTripWidget extends StatelessWidget {
  final BusTrip busTrip;
  final DateTime selectedDate;
  const BusTripWidget({
    super.key,
    required this.busTrip,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
      child: Column(
        children: [
          Text(
            (busTrip.departureTime.inMinutes -
                        Duration(
                          hours: selectedDate.hour,
                          minutes: selectedDate.minute,
                        ).inMinutes <
                    60)
                ? 'Saída em'
                : 'Saída às',
            style: TextStyle(
              color: SorrisinhoTheme.primaryColor,
              fontSize: 14,
            ),
          ),
          Text(
            isToday(selectedDate) &&
                    (busTrip.departureTime.inMinutes -
                            Duration(
                              hours: selectedDate.hour,
                              minutes: selectedDate.minute,
                            ).inMinutes <
                        60)
                ? (busTrip.departureTime.inMinutes -
                        Duration(
                          hours: selectedDate.hour,
                          minutes: selectedDate.minute,
                        ).inMinutes)
                    .toString()
                : '${busTrip.departureTime.inHours.toString().padLeft(2, '0')}:${busTrip.departureTime.inMinutes.remainder(60).toString().padLeft(2, '0')}',
            style: TextStyle(
              color: SorrisinhoTheme.primaryColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            (busTrip.departureTime.inMinutes -
                        Duration(
                          hours: selectedDate.hour,
                          minutes: selectedDate.minute,
                        ).inMinutes <
                    60)
                ? (busTrip.departureTime.inMinutes -
                            Duration(
                              hours: selectedDate.hour,
                              minutes: selectedDate.minute,
                            ).inMinutes <=
                        1)
                    ? 'minuto'
                    : 'minutos'
                : ' ',
            style: TextStyle(
              color: SorrisinhoTheme.primaryColor,
              fontSize: 14,
            ),
          ),
          Text(
            'Linha ${busTrip.lineNumber}',
            style: TextStyle(
              color: SorrisinhoTheme.informationBackgroundColor,
              fontSize: 12,
            ),
          ),
          const Text(
            'Chegada às',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
          Text(
            '${busTrip.arrivalTime.inHours.toString().padLeft(2, '0')}:${busTrip.arrivalTime.inMinutes.remainder(60).toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

String getTitle(DateTime date) {
  if (isToday(date)) {
    return 'hoje';
  }

  if (date.weekday == 1) {
    return 'segunda à sexta';
  }

  return getWeekdayNameFromNumber(date.weekday).toLowerCase();
}

final Map<int, DateTime> randomTimeByNumber = {
  0: DateTime.now(),
  1: randomMonday,
  2: randomSaturday,
};

DateTime randomMonday = DateTime(2024, 6, 17);
DateTime randomSaturday = DateTime(2024, 6, 22);
