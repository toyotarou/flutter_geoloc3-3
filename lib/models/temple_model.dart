import '../extensions/extensions.dart';

class TempleModel {
  TempleModel({
    required this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.temple,
    required this.memo,
    required this.address,
    required this.station,
    required this.gohonzon,
    required this.lat,
    required this.lng,
    required this.startPoint,
    required this.endPoint,
  });

  factory TempleModel.fromJson(Map<String, dynamic> json) => TempleModel(
        id: json['id'].toString().toInt(),
        year: json['year'].toString(),
        month: json['month'].toString(),
        day: json['day'].toString(),
        temple: json['temple'].toString(),
        memo: (json['memo'] == null) ? null : json['memo'].toString(),
        address: json['address'].toString(),
        station: json['station'].toString(),
        gohonzon: (json['gohonzon'] == null) ? null : json['gohonzon'].toString(),
        lat: json['lat'].toString(),
        lng: json['lng'].toString(),
        startPoint: json['start_point'].toString(),
        endPoint: json['end_point'].toString(),
      );
  int id;
  String year;
  String month;
  String day;
  String temple;
  String? memo;
  String address;
  String station;
  String? gohonzon;
  String lat;
  String lng;
  String startPoint;
  String endPoint;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'year': year,
        'month': month,
        'day': day,
        'temple': temple,
        'memo': memo,
        'address': address,
        'station': station,
        'gohonzon': gohonzon,
        'lat': lat,
        'lng': lng,
        'start_point': startPoint,
        'end_point': endPoint,
      };
}
