import '../extensions/extensions.dart';

class TempleLatlngModel {
  TempleLatlngModel(
      {required this.id, required this.temple, required this.address, required this.lat, required this.lng});

  factory TempleLatlngModel.fromJson(Map<String, dynamic> json) => TempleLatlngModel(
        id: json['id'].toString().toInt(),
        temple: json['temple'].toString(),
        address: json['address'].toString(),
        lat: json['lat'].toString(),
        lng: json['lng'].toString(),
      );
  int id;
  String temple;
  String address;
  String lat;
  String lng;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'temple': temple, 'address': address, 'lat': lat, 'lng': lng};
}

class TempleInfoModel {
  TempleInfoModel({required this.temple, required this.address, required this.latitude, required this.longitude});

  String temple;
  String address;
  String latitude;
  String longitude;
}
