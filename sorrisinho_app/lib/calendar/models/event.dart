class Event {
  final String name;
  final String? description;
  final String? link;
  final DateTime date;

  const Event({
    required this.name,
    required this.date,
    this.description,
    this.link,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'],
      description: json['description'],
      link: json['link'],
      date: DateTime.parse(
        json['date'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'link': link,
      'date': date.toIso8601String(),
    };
  }

  factory Event.decodeFromStorage(dynamic storageValue) {
    return Event(
      name: storageValue['name'],
      description: storageValue['description'],
      link: storageValue['link'],
      date: DateTime.parse(
        storageValue['date'],
      ),
    );
  }
}
