import 'package:isar/isar.dart';

import '../collections/geoloc.dart';
import 'isar_repository.dart';

class GeolocRepository {
  ///
  Future<List<Geoloc>?> getAllGeoloc() async {
    await IsarRepository.configure();

    return IsarRepository.isar.geolocs.where().findAll();
  }
}
