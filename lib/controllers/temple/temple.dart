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
    @Default(<String, List<String>>{}) Map<String, List<String>> templeVisitedDateMap,
    @Default(<String, List<String>>{}) Map<String, List<String>> yearVisitedDateMap,
    @Default(<List<String>>[]) List<List<String>> templeSearchValueList,
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
    await client.get(path: 'temple').then((templeValue) async {
      final List<TempleInfoModel> list = <TempleInfoModel>[];
      final Map<String, List<TempleInfoModel>> map = <String, List<TempleInfoModel>>{};

      final Map<String, List<String>> map2 = <String, List<String>>{};

      final Map<String, List<String>> map3 = <String, List<String>>{};

      final List<List<String>> list2 = <List<String>>[];

      //===============================================================================//

      final Map<String, TempleInfoModel> latlngModel = <String, TempleInfoModel>{};

      // ignore: always_specify_types
      await client.get(path: 'temple/latlng').then((templeLatLngValue) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < templeLatLngValue.length.toString().toInt(); i++) {
          final TempleLatlngModel templeLatLngModelValueData =
              // ignore: avoid_dynamic_calls
              TempleLatlngModel.fromJson(templeLatLngValue[i] as Map<String, dynamic>);

          latlngModel[templeLatLngModelValueData.temple] = TempleInfoModel(
              temple: templeLatLngModelValueData.temple,
              address: templeLatLngModelValueData.address,
              latitude: templeLatLngModelValueData.lat,
              longitude: templeLatLngModelValueData.lng);
        }
        // ignore: always_specify_types
      }).catchError((error, _) {
        utility.showError('予期せぬエラーが発生しました2');
      });

      //===============================================================================//

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < templeValue.length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final TempleModel templeModelValueData = TempleModel.fromJson(templeValue[i] as Map<String, dynamic>);

        map['${templeModelValueData.year}-${templeModelValueData.month}-${templeModelValueData.day}'] =
            <TempleInfoModel>[];

        map3[templeModelValueData.year] = <String>[];

        ////////////////////////////////////////////
        map2[templeModelValueData.temple] = <String>[];

        templeModelValueData.memo?.split('、').forEach((String element) => map2[element] = <String>[]);

        ////////////////////////////////////////////
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < templeValue.length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final TempleModel templeModelValueData2 = TempleModel.fromJson(templeValue[i] as Map<String, dynamic>);

        /// templeとmemoを分割した神社名をリストに入れる
        final List<String> templeName = <String>[templeModelValueData2.temple];
        templeModelValueData2.memo?.split('、').forEach((String element) => templeName.add(element));

        list2.add(templeName);

        ///

        map2[templeModelValueData2.temple]
            ?.add('${templeModelValueData2.year}-${templeModelValueData2.month}-${templeModelValueData2.day}');

        //___________________________________________________________
        for (final String element2 in templeName) {
          final TempleInfoModel? templeInfoModelValueData = latlngModel[element2];

          //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
          if (templeInfoModelValueData != null) {
            final TempleInfoModel templeInfoModel = TempleInfoModel(
                temple: templeInfoModelValueData.temple,
                address: templeInfoModelValueData.address,
                latitude: templeInfoModelValueData.latitude,
                longitude: templeInfoModelValueData.longitude);

            list.add(templeInfoModel);

            map['${templeModelValueData2.year}-${templeModelValueData2.month}-${templeModelValueData2.day}']
                ?.add(templeInfoModel);
          }
          //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

          map2[element2]
              ?.add('${templeModelValueData2.year}-${templeModelValueData2.month}-${templeModelValueData2.day}');
        }
        //___________________________________________________________

        map3[templeModelValueData2.year]
            ?.add('${templeModelValueData2.year}-${templeModelValueData2.month}-${templeModelValueData2.day}');
      }

      state = state.copyWith(
        templeInfoList: list,
        templeInfoMap: map,
        templeVisitedDateMap: map2,
        yearVisitedDateMap: map3,
        templeSearchValueList: list2,
      );
      // ignore: always_specify_types
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }
}
