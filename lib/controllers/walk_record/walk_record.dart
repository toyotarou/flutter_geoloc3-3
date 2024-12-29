import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../extensions/extensions.dart';
import '../../models/walk_record_model.dart';
import '../../utilities/utilities.dart';

part 'walk_record.freezed.dart';

part 'walk_record.g.dart';

@freezed
class WalkRecordControllerState with _$WalkRecordControllerState {
  const factory WalkRecordControllerState({
    @Default(<WalkRecordModel>[]) List<WalkRecordModel> walkRecordList,
    @Default(<String, WalkRecordModel>{}) Map<String, WalkRecordModel> walkRecordMap,
  }) = _WalkRecordControllerState;
}

@Riverpod(keepAlive: true)
class WalkRecordController extends _$WalkRecordController {
  final Utility utility = Utility();

  ///
  @override
  WalkRecordControllerState build() => const WalkRecordControllerState();

  ///
  Future<void> getYearWalkRecord({required String yearmonth}) async {
    final HttpClient client = ref.read(httpClientProvider);

    // ignore: always_specify_types
    await client.get(path: 'walkRecord/year/${yearmonth.split('-')[0]}').then((value) {
      final List<WalkRecordModel> list = <WalkRecordModel>[];
      final Map<String, WalkRecordModel> map = <String, WalkRecordModel>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value.length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final WalkRecordModel val = WalkRecordModel.fromJson(value[i] as Map<String, dynamic>);

        list.add(val);

        map['${val.year}-${val.month.padLeft(2, '0')}-${val.day.padLeft(2, '0')}'] = val;
      }

      state = state.copyWith(walkRecordList: list, walkRecordMap: map);
      //ignore: always_specify_types
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }
}
