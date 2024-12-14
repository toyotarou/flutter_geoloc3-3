import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../utilities/utilities.dart';

part 'geoloc.freezed.dart';
part 'geoloc.g.dart';

@freezed
class GeolocState with _$GeolocState {
  const factory GeolocState({
    @Default(<GeolocModel>[]) List<GeolocModel> geolocList,
    @Default(<String, List<GeolocModel>>{}) Map<String, List<GeolocModel>> geolocMap,
    @Default('') String selectedFundName,
  }) = _GeolocState;
}

@Riverpod(keepAlive: true)
class Geoloc extends _$Geoloc {
  final Utility utility = Utility();

  ///
  @override
  GeolocState build() => const GeolocState();

  ///
  Future<void> inputGeoloc({required String latitude, required String longitude}) async {
    final HttpClient client = ref.read(httpClientProvider);

    final DateTime now = DateTime.now();
    final DateFormat timeFormat = DateFormat('HH:mm:ss');
    final String currentTime = timeFormat.format(now);

    final Map<String, String> map = <String, String>{
      'year': DateTime.now().yyyymmdd.split('-')[0],
      'month': DateTime.now().yyyymmdd.split('-')[1],
      'day': DateTime.now().yyyymmdd.split('-')[2],
      'time': currentTime,
      'latitude': latitude,
      'longitude': longitude,
    };

    // ignore: always_specify_types
    await client.post(path: 'geoloc', body: map).then((value) {}).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }
}
