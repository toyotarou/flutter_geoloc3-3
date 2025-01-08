import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

import '../../models/geoloc_model.dart';
import '../../models/temple_latlng_model.dart';

part 'app_params_response_state.freezed.dart';

@freezed
class AppParamsResponseState with _$AppParamsResponseState {
  const factory AppParamsResponseState({
    DateTime? calendarSelectedDate,
    GeolocModel? selectedTimeGeoloc,
    @Default(true) bool isMarkerShow,
    @Default('') String selectedHour,
    @Default(0) double currentZoom,
    @Default(5) int currentPaddingIndex,
    LatLng? currentCenter,
    @Default(false) bool isTempleCircleShow,
    GeolocModel? polylineGeolocModel,
    TempleInfoModel? selectedTemple,
    @Default(-1) int timeGeolocDisplayStart,
    @Default(-1) int timeGeolocDisplayEnd,
  }) = _AppParamsResponseState;
}
