import 'package:isar/isar.dart';

part 'config.g.dart';

@collection
class Config {
  Id id = Isar.autoIncrement;

  late String configKey;
  late String configValue;
}
