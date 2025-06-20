import 'package:isar/isar.dart';

import '../collections/kotlin_room_data.dart';
import 'isar_repository.dart';

class KotlinRoomDataRepository {
  ///
  Future<List<KotlinRoomData>?> getKotlinRoomDataList() async {
    await IsarRepository.configure();
    return IsarRepository.isar.kotlinRoomDatas.where().sortByDateDesc().thenByTimeDesc().findAll();
  }

  ///
  Future<void> inputKotlinRoomDataList({required List<KotlinRoomData> kotlinRoomDataList}) async {
    for (final KotlinRoomData element in kotlinRoomDataList) {
      inputKotlinRoomData(kotlinRoomData: element);
    }
  }

  ///
  Future<void> inputKotlinRoomData({required KotlinRoomData kotlinRoomData}) async {
    await IsarRepository.configure();
    await IsarRepository.isar.writeTxn(() async => IsarRepository.isar.kotlinRoomDatas.put(kotlinRoomData));
  }

  ///
  Future<void> deleteKotlinRoomDataList({required List<KotlinRoomData>? kotlinRoomDataList}) async {
    kotlinRoomDataList?.forEach((KotlinRoomData element) => deleteKotlinRoomData(id: element.id));
  }

  ///
  Future<void> deleteKotlinRoomData({required int id}) async {
    await IsarRepository.configure();
    IsarRepository.isar.writeTxn(() => IsarRepository.isar.kotlinRoomDatas.delete(id));
  }
}
