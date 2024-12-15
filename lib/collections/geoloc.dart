import 'package:isar/isar.dart';

part 'geoloc.g.dart';

@collection
class Geoloc {
  Id id = Isar.autoIncrement;

  late String date;
  late String time;
  late String latitude;
  late String longitude;
}
