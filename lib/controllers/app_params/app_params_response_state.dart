import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_params_response_state.freezed.dart';

@freezed
class AppParamsResponseState with _$AppParamsResponseState {
  const factory AppParamsResponseState({
    DateTime? calendarSelectedDate,
    @Default(0) int menuNumber,
    @Default('') String selectedIncomeYear,
    @Default(false) bool sameMonthIncomeDeleteFlag,
    @Default('') String incomeInputDate,
    @Default(false) bool inputButtonClicked,
    @Default(0) int sameDaySelectedDay,
    @Default(0) int selectedGraphMonth,
    @Default(true) bool calendarDisp,
    @Default('') String selectedYearlySpendCircleGraphSpendItem,
  }) = _AppParamsResponseState;
}
