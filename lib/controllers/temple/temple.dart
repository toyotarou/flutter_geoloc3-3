import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../extensions/extensions.dart';
import '../../models/temple_latlng_model.dart';
import '../../models/temple_model.dart';
import '../../utilities/utilities.dart';

part 'temple.freezed.dart';

part 'temple.g.dart';

@freezed
class TempleControllerState with _$TempleControllerState {
  const factory TempleControllerState({
    @Default(<TempleInfoModel>[]) List<TempleInfoModel> templeInfoList,
    @Default(<String, List<TempleInfoModel>>{}) Map<String, List<TempleInfoModel>> templeInfoMap,
  }) = _TempleControllerState;
}

@Riverpod(keepAlive: true)
class TempleController extends _$TempleController {
  final Utility utility = Utility();

  ///
  @override
  TempleControllerState build() => const TempleControllerState();

  ///
  Future<void> getAllTempleModel() async {
    final HttpClient client = ref.read(httpClientProvider);

    // ignore: always_specify_types
    await client.get(path: 'temple').then((value2) async {
      final List<TempleInfoModel> list = <TempleInfoModel>[];
      final Map<String, List<TempleInfoModel>> map = <String, List<TempleInfoModel>>{};

      final Map<String, TempleInfoModel> latlngModel = <String, TempleInfoModel>{};

      // ignore: always_specify_types
      await client.get(path: 'temple/latlng').then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value.length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final TempleLatlngModel val = TempleLatlngModel.fromJson(value[i] as Map<String, dynamic>);

          latlngModel[val.temple] =
              TempleInfoModel(temple: val.temple, address: val.address, latitude: val.lat, longitude: val.lng);
        }
        // ignore: always_specify_types
      }).catchError((error, _) {
        utility.showError('予期せぬエラーが発生しました2');
      });

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value2.length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final TempleModel val2 = TempleModel.fromJson(value2[i] as Map<String, dynamic>);

        map['${val2.year}-${val2.month}-${val2.day}'] = <TempleInfoModel>[];
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value2.length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final TempleModel val2 = TempleModel.fromJson(value2[i] as Map<String, dynamic>);

        final List<String> templeName = <String>[val2.temple];
        val2.memo?.split('、').forEach((String element) => templeName.add(element));

        for (final String element2 in templeName) {
          final TempleInfoModel? latlng = latlngModel[element2];

          if (latlng != null) {
            final TempleInfoModel templeInfoModel = TempleInfoModel(
                temple: latlng.temple, address: latlng.address, latitude: latlng.latitude, longitude: latlng.longitude);

            list.add(templeInfoModel);

            map['${val2.year}-${val2.month}-${val2.day}']?.add(templeInfoModel);
          }
        }
      }

      state = state.copyWith(templeInfoList: list, templeInfoMap: map);
      // ignore: always_specify_types
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }
}
