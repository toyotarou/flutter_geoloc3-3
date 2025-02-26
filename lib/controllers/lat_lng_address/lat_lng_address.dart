import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/lat_lng_address.dart';
import '../../utilities/utilities.dart';

part 'lat_lng_address.freezed.dart';

part 'lat_lng_address.g.dart';

@freezed
class LatLngAddressControllerState with _$LatLngAddressControllerState {
  const factory LatLngAddressControllerState({
    @Default(<LatLngAddressDetailModel>[]) List<LatLngAddressDetailModel> latLngAddressList,
    @Default(<String, List<LatLngAddressDetailModel>>{}) Map<String, List<LatLngAddressDetailModel>> latLngAddressMap,
  }) = _LatLngAddressControllerState;
}

@Riverpod(keepAlive: true)
class LatLngAddressController extends _$LatLngAddressController {
  final Utility utility = Utility();

  ///
  @override
  Future<LatLngAddressControllerState> build({required String latitude, required String longitude}) async {
    return getLatLngAddress(latitude: latitude, longitude: longitude);
  }

  ///
  Future<LatLngAddressControllerState> getLatLngAddress({required String latitude, required String longitude}) async {
    final String url = 'https://geoapi.heartrails.com/api/json?method=searchByGeoLocation&x=$longitude&y=$latitude';

    final Response response = await get(Uri.parse(url));

    final LatLngAddressModel result = latLngAddressFromJson(response.body);

    final List<LatLngAddressDetailModel> list = <LatLngAddressDetailModel>[];
    final Map<String, List<LatLngAddressDetailModel>> map = <String, List<LatLngAddressDetailModel>>{};

    for (int i = 0; i < result.response.location.length; i++) {
      final LatLngAddressDetailModel val = result.response.location[i];

      list.add(val);

      map['${val.y}|${val.x}'] = <LatLngAddressDetailModel>[];
    }

    for (int i = 0; i < result.response.location.length; i++) {
      final LatLngAddressDetailModel val = result.response.location[i];

      map['${val.y}|${val.x}']?.add(val);
    }

    return LatLngAddressControllerState(latLngAddressList: list, latLngAddressMap: map);
  }
}
