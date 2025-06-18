import 'package:pigeon/pigeon.dart';

class WifiLocation {
  WifiLocation({
    required this.date,
    required this.time,
    required this.ssid,
    required this.latitude,
    required this.longitude,
  });

  String date;
  String time;
  String ssid;
  String latitude;
  String longitude;
}

@HostApi()
abstract class WifiLocationApi {
  List<WifiLocation> getWifiLocations();

  void deleteAllWifiLocations();

  void startLocationCollection();

  bool isCollecting();
}
