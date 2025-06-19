import 'package:isar/isar.dart';

part 'kotlin_room_data.g.dart';

@collection
class KotlinRoomData {
  Id id = Isar.autoIncrement;

  late String date;
  late String time;
  late String ssid;
  late String latitude;
  late String longitude;
}
