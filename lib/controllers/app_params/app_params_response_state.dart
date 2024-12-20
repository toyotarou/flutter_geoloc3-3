import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/geoloc_model.dart';

part 'app_params_response_state.freezed.dart';

@freezed
class AppParamsResponseState with _$AppParamsResponseState {
  const factory AppParamsResponseState({
    DateTime? calendarSelectedDate,
    GeolocModel? selectedTimeGeoloc,
    @Default(false) bool isMarkerHide,
  }) = _AppParamsResponseState;
}
