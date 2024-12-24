class Discipline {
  final int id;
  final String name;
  final String campus;
  final String period;
  final String code;
  final String classCode;
  final String tpi;
  final String course;

  const Discipline({
    required this.id,
    required this.name,
    required this.campus,
    required this.period,
    required this.code,
    required this.classCode,
    required this.tpi,
    required this.course,
  });

  @override
  bool operator ==(Object other) {
    return other is Discipline &&
        name == other.name &&
        campus == other.campus &&
        period == other.period &&
        classCode == other.classCode &&
        code == other.code &&
        tpi == other.tpi;
  }

  @override
  int get hashCode => id;

  factory Discipline.fromJson(Map<String, dynamic> json) {
    return Discipline(
      id: json['id'],
      name: json['name'],
      campus: json['campus'],
      period: json['period'],
      code: json['code'],
      classCode: json['classCode'],
      tpi: json['tpi'],
      course: json['course'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'campus': campus,
      'period': period,
      'code': code,
      'classCode': classCode,
      'tpi': tpi,
      'course': course,
    };
  }

  factory Discipline.decodeFromStorage(dynamic storageValue) {
    return Discipline(
      id: storageValue['id'],
      name: storageValue['name'],
      campus: storageValue['campus'],
      period: storageValue['period'],
      code: storageValue['code'],
      classCode: storageValue['classCode'],
      tpi: storageValue['tpi'],
      course: storageValue['course'],
    );
  }
}
