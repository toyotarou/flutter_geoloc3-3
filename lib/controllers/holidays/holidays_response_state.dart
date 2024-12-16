// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'holidays_response_state.freezed.dart';

@freezed
class HolidaysResponseState with _$HolidaysResponseState {
  const factory HolidaysResponseState({
    @Default(AsyncValue<Map<String, String>>.loading()) AsyncValue<Map<String, String>> holidayMap,
  }) = _HolidaysResponseState;
}
