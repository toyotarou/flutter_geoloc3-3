import '../extensions/extensions.dart';

class GeolocModel {
  GeolocModel({
    required this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.time,
    required this.latitude,
    required this.longitude,
  });

  factory GeolocModel.fromJson(Map<String, dynamic> json) => GeolocModel(
        id: json['id'].toString().toInt(),
        year: json['year'].toString(),
        month: json['month'].toString(),
        day: json['day'].toString(),
        time: json['time'].toString(),
        latitude: json['latitude'].toString(),
        longitude: json['longitude'].toString(),
      );
  int id;
  String year;
  String month;
  String day;
  String time;
  String latitude;
  String longitude;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'year': year,
        'month': month,
        'day': day,
        'time': time,
        'latitude': latitude,
        'longitude': longitude,
      };
}
