import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendars_response_state.freezed.dart';

@freezed
class CalendarsResponseState with _$CalendarsResponseState {
  const factory CalendarsResponseState({
    @Default('') String baseYearMonth,
    @Default('') String prevYearMonth,
    @Default('') String nextYearMonth,
  }) = _CalendarsResponseState;
}
