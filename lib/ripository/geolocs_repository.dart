import 'package:isar/isar.dart';

import '../collections/geoloc.dart';
import 'isar_repository.dart';

class GeolocRepository {
  ///
  Future<List<Geoloc>?> getAllIsarGeoloc() async {
    await IsarRepository.configure();
    return IsarRepository.isar.geolocs.where().sortByDateDesc().thenByTimeDesc().findAll();
  }

  ///
  Future<Geoloc?> getRecentOneGeoloc() async {
    await IsarRepository.configure();
    return IsarRepository.isar.geolocs.where().sortByDateDesc().thenByTimeDesc().findFirst();
  }

  ///
  Future<void> deleteGeolocList({required List<Geoloc>? geolocList}) async {
    geolocList?.forEach((Geoloc element) => deleteGeoloc(id: element.id));
  }

  ///
  Future<void> deleteGeoloc({required int id}) async {
    await IsarRepository.configure();
    IsarRepository.isar.writeTxn(() => IsarRepository.isar.geolocs.delete(id));
  }
}
