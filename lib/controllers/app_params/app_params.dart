import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../enums/map_type.dart';
import '../../models/geoloc_model.dart';
import '../../models/temple_latlng_model.dart';

part 'app_params.freezed.dart';

part 'app_params.g.dart';

@freezed
class AppParamsState with _$AppParamsState {
  const factory AppParamsState({
    DateTime? calendarSelectedDate,
    GeolocModel? selectedTimeGeoloc,
    @Default(true) bool isMarkerShow,

    ///

    @Default(0) double currentZoom,
    @Default(5) int currentPaddingIndex,
    LatLng? currentCenter,
    @Default(false) bool isTempleCircleShow,
    GeolocModel? polylineGeolocModel,
    TempleInfoModel? selectedTemple,

    ///

    @Default(-1) int timeGeolocDisplayStart,
    @Default(-1) int timeGeolocDisplayEnd,

    ///

    List<OverlayEntry>? bigEntries,
    void Function(VoidCallback fn)? setStateCallback,
    @Default(<String>[]) List<String> monthGeolocAddMonthButtonLabelList,
    Offset? overlayPosition,
    List<OverlayEntry>? firstEntries,
    List<OverlayEntry>? secondEntries,

    ///
    @Default(false) bool visitedTempleMapDisplayFinish,
    @Default(-1) int selectedTimeGeolocIndex,

    ///

    MapType? mapType,

    ///

    @Default('') String mapControlDisplayDate,
  }) = _AppParamsState;
}

@Riverpod(keepAlive: true)
class AppParams extends _$AppParams {
  ///
  @override
  AppParamsState build() => const AppParamsState();

  ///
  void setCalendarSelectedDate({required DateTime date}) => state = state.copyWith(calendarSelectedDate: date);

  ///
  void setSelectedTimeGeoloc({GeolocModel? geoloc}) => state = state.copyWith(selectedTimeGeoloc: geoloc);

  ///
  void setIsMarkerShow({required bool flag}) => state = state.copyWith(isMarkerShow: flag);

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
  void setTempleGeolocTimeCircleAvatarParams(
          {required List<OverlayEntry>? bigEntries, required void Function(VoidCallback fn)? setStateCallback}) =>
      state = state.copyWith(bigEntries: bigEntries, setStateCallback: setStateCallback);

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

  ///
  void clearMonthGeolocAddMonthButtonLabelList() =>
      state = state.copyWith(monthGeolocAddMonthButtonLabelList: <String>[]);

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

  ///
  void setMapControlDisplayDate({required String date}) => state = state.copyWith(mapControlDisplayDate: date);
}
