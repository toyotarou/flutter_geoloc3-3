import 'dart:convert';

import '../extensions/extensions.dart';

LatLngAddressModel latLngAddressFromJson(String str) =>
    LatLngAddressModel.fromJson(json.decode(str) as Map<String, dynamic>);

String latLngAddressToJson(LatLngAddressModel data) => json.encode(data.toJson());

class LatLngAddressModel {
  LatLngAddressModel({required this.response});

  factory LatLngAddressModel.fromJson(Map<String, dynamic> json) =>
      LatLngAddressModel(response: LatLngAddressResponseModel.fromJson(json['response'] as Map<String, dynamic>));

  LatLngAddressResponseModel response;

  Map<String, dynamic> toJson() => <String, dynamic>{'response': response.toJson()};
}

class LatLngAddressResponseModel {
  LatLngAddressResponseModel({required this.location});

  factory LatLngAddressResponseModel.fromJson(Map<String, dynamic> json) => LatLngAddressResponseModel(
      // ignore: avoid_dynamic_calls
      location: List<LatLngAddressDetailModel>.from(json['location']
          // ignore: inference_failure_on_untyped_parameter, always_specify_types
          .map((x) => LatLngAddressDetailModel.fromJson(x as Map<String, dynamic>)) as Iterable<dynamic>));

  List<LatLngAddressDetailModel> location;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'location': List<dynamic>.from(location.map((LatLngAddressDetailModel x) => x.toJson()))};
}

class LatLngAddressDetailModel {
  LatLngAddressDetailModel({
    required this.city,
    required this.cityKana,
    required this.town,
    required this.townKana,
    required this.x,
    required this.y,
    required this.distance,
    required this.prefecture,
    required this.postal,
  });

  factory LatLngAddressDetailModel.fromJson(Map<String, dynamic> json) => LatLngAddressDetailModel(
        city: json['city'].toString(),
        cityKana: json['city_kana'].toString(),
        town: json['town'].toString(),
        townKana: json['town_kana'].toString(),
        x: json['x'].toString(),
        y: json['y'].toString(),
        distance: json['distance'].toString().toDouble(),
        prefecture: json['prefecture'].toString(),
        postal: json['postal'].toString(),
      );
  String city;
  String cityKana;
  String town;
  String townKana;
  String x;
  String y;
  double distance;
  String prefecture;
  String postal;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'city': city,
        'city_kana': cityKana,
        'town': town,
        'town_kana': townKana,
        'x': x,
        'y': y,
        'distance': distance,
        'prefecture': prefecture,
        'postal': postal,
      };
}
