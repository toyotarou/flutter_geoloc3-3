import '../extensions/extensions.dart';

class WalkRecordModel {
  WalkRecordModel(
      {required this.id,
      required this.year,
      required this.month,
      required this.day,
      required this.step,
      required this.distance});

  factory WalkRecordModel.fromJson(Map<String, dynamic> json) => WalkRecordModel(
        id: json['id'].toString().toInt(),
        year: json['year'].toString(),
        month: json['month'].toString(),
        day: json['day'].toString(),
        step: json['step'].toString().toInt(),
        distance: json['distance'].toString().toInt(),
      );
  int id;
  String year;
  String month;
  String day;
  int step;
  int distance;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'year': year, 'month': month, 'day': day, 'step': step, 'distance': distance};
}
