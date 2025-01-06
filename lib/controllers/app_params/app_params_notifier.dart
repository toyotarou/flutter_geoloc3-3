import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
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
}
