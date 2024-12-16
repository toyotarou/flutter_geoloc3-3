import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../collections/config.dart';
import '../collections/geoloc.dart';

class IsarRepository {
  IsarRepository._();

  static Isar get isar => _isar!;

  static Isar? _isar;

  static Future<void> configure() async {
    if (_isar != null) {
      return;
    }

    final Directory dir = await getApplicationDocumentsDirectory();

    // ignore: strict_raw_type, always_specify_types
    _isar = await Isar.open(<CollectionSchema>[
      GeolocSchema,
      ConfigSchema,
    ], directory: dir.path);
  }
}
