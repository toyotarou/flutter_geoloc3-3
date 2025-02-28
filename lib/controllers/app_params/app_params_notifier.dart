import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../enums/map_type.dart';
import '../../models/geoloc_model.dart';
import '../../models/temple_latlng_model.dart';
import 'app_params_response_state.dart';

final AutoDisposeStateNotifierProvider<AppParamNotifier, AppParamsResponseState> appParamProvider =
    StateNotifierProvider.autoDispose<AppParamNotifier, AppParamsResponseState>(
        (AutoDisposeStateNotifierProviderRef<AppParamNotifier, AppParamsResponseState> ref) {
  return AppParamNotifier(const AppParamsResponseState());
});

class AppParamNotifier extends StateNotifier<AppParamsResponseState> {
  AppParamNotifier(super.state);

  ///
  void setCalendarSelectedDate({required DateTime date}) => state = state.copyWith(calendarSelectedDate: date);

  ///
  void setSelectedTimeGeoloc({GeolocModel? geoloc}) => state = state.copyWith(selectedTimeGeoloc: geoloc);

  ///
  void setIsMarkerShow({required bool flag}) => state = state.copyWith(isMarkerShow: flag);

  // ///
  // void setSelectedHour({required String hour}) => state = state.copyWith(selectedHour: hour);

  ///
  void setCurrentZoom({required double zoom}) => state = state.copyWith(currentZoom: zoom);

  ///
  void setCurrentPaddingIndex({required int index}) => state = state.copyWith(currentPaddingIndex: index);

  ///
  void setCurrentCenter({required LatLng latLng}) => state = state.copyWith(currentCenter: latLng);

  ///
  void setIsTempleCircleShow({required bool flag}) => state = state.copyWith(isTempleCircleShow: flag);

  ///
  void setPolylineGeolocModel({required GeolocModel model}) => state = state.copyWith(polylineGeolocModel: model);

  ///
  void setSelectedTemple({required TempleInfoModel temple}) => state = state.copyWith(selectedTemple: temple);

  ///
  void setTimeGeolocDisplay({required int start, required int end}) =>
      state = state.copyWith(timeGeolocDisplayStart: start, timeGeolocDisplayEnd: end);

  ///
  void setTempleGeolocTimeCircleAvatarParams({
    required List<OverlayEntry>? bigEntries,
    required void Function(VoidCallback fn)? setStateCallback,
  }) {
    state = state.copyWith(bigEntries: bigEntries, setStateCallback: setStateCallback);
  }

  ///
  void setMonthGeolocAddMonthButtonLabelList({required String str}) {
    final List<String> list = <String>[...state.monthGeolocAddMonthButtonLabelList];

    if (!list.contains(str)) {
      list.add(str);
    } else {
      list.remove(str);
    }

    state = state.copyWith(monthGeolocAddMonthButtonLabelList: list);
  }

  ///////////////////////////////

  ///
  void updateOverlayPosition(Offset newPos) => state = state.copyWith(overlayPosition: newPos);

  ///
  void setFirstOverlayParams({required List<OverlayEntry>? firstEntries}) =>
      state = state.copyWith(firstEntries: firstEntries);

  ///
  void setSecondOverlayParams({required List<OverlayEntry>? secondEntries}) =>
      state = state.copyWith(secondEntries: secondEntries);

  ///
  void setSelectedTimeGeolocIndex({required int index}) => state = state.copyWith(selectedTimeGeolocIndex: index);

  ///
  void setMapType({required MapType type}) => state = state.copyWith(mapType: type);
}
