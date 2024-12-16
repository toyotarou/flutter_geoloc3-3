import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'app_params_response_state.dart';

final AutoDisposeStateNotifierProvider<AppParamNotifier, AppParamsResponseState> appParamProvider =
    StateNotifierProvider.autoDispose<AppParamNotifier, AppParamsResponseState>(
        (AutoDisposeStateNotifierProviderRef<AppParamNotifier, AppParamsResponseState> ref) {
  final int day = DateTime.now().day;

  return AppParamNotifier(AppParamsResponseState(sameDaySelectedDay: day));
});

class AppParamNotifier extends StateNotifier<AppParamsResponseState> {
  AppParamNotifier(super.state);

  ///
  void setCalendarSelectedDate({required DateTime date}) => state = state.copyWith(calendarSelectedDate: date);

  ///
  void setMenuNumber({required int menuNumber}) => state = state.copyWith(menuNumber: menuNumber);

  ///
  void setSelectedIncomeYear({required String year}) => state = state.copyWith(selectedIncomeYear: year);

  ///
  void setSameMonthIncomeDeleteFlag({required bool flag}) => state = state.copyWith(sameMonthIncomeDeleteFlag: flag);

  ///
  void setIncomeInputDate({required String date}) => state = state.copyWith(incomeInputDate: date);

  ///
  Future<void> setInputButtonClicked({required bool flag}) async => state = state.copyWith(inputButtonClicked: flag);

  ///
  void setSameDaySelectedDay({required int day}) => state = state.copyWith(sameDaySelectedDay: day);

  ///
  void setSelectedGraphMonth({required int month}) => state = state.copyWith(selectedGraphMonth: month);

  ///
  void setCalendarDisp({required bool flag}) => state = state.copyWith(calendarDisp: flag);

  ///
  void setSelectedYearlySpendCircleGraphSpendItem({required String item}) =>
      state = state.copyWith(selectedYearlySpendCircleGraphSpendItem: item);
}
