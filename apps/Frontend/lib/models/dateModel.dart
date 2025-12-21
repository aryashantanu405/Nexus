class DateModel{
  final int year;
  final int month;
  final int day;
  int? hour;
  int? minute;
  int?second;
  int? millisecond;

  DateModel({required this.year, required this.month, required this.day, this.hour, this. millisecond, this.minute, this.second});

  factory DateModel.fromJson(Map<String, dynamic> json)
  {
    return DateModel(year: json["year"], month: json["month"], day: json["day"], hour: json["hour"], minute: json["minute"], second: json["second"],
    millisecond: json["millisecond"]);
  }
}