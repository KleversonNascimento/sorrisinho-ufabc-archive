import 'package:amplitude_flutter/amplitude.dart';

class EventTracker {
  static final EventTracker _singleton = EventTracker._internal();

  factory EventTracker() {
    return _singleton;
  }

  late Amplitude amplitudeInstance;

  void init() {
    amplitudeInstance = Amplitude.getInstance(instanceName: 'insert instance name here');
    amplitudeInstance.init('insert id here');
  }

  void sendEvent({
    required String eventName,
    Map<String, dynamic>? eventProps,
  }) {
    amplitudeInstance.logEvent(
      eventName,
      eventProperties: eventProps,
    );
  }

  EventTracker._internal();
}
