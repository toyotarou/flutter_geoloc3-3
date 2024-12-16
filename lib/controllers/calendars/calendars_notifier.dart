import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../extensions/extensions.dart';

import 'calendars_response_state.dart';

////////////////////////////////////////////////

final AutoDisposeStateNotifierProvider<CalendarNotifier, CalendarsResponseState>
    calendarProvider =
    StateNotifierProvider.autoDispose<CalendarNotifier, CalendarsResponseState>(
        (AutoDisposeStateNotifierProviderRef<CalendarNotifier,
                CalendarsResponseState>
            ref) {
  return CalendarNotifier(const CalendarsResponseState())
    ..setCalendarYearMonth();
});

class CalendarNotifier extends StateNotifier<CalendarsResponseState> {
  CalendarNotifier(super.state);

  ///
  Future<void> setCalendarYearMonth({String? baseYm}) async {
    final String baseYearMonth =
        (baseYm != null) ? baseYm : DateTime.now().yyyymm;

    final String prevYearMonth = DateTime(baseYearMonth.split('-')[0].toInt(),
            baseYearMonth.split('-')[1].toInt() - 1)
        .yyyymm;
    final String nextYearMonth = DateTime(baseYearMonth.split('-')[0].toInt(),
            baseYearMonth.split('-')[1].toInt() + 1)
        .yyyymm;

    state = state.copyWith(
        baseYearMonth: baseYearMonth,
        prevYearMonth: prevYearMonth,
        nextYearMonth: nextYearMonth);
  }
}

////////////////////////////////////////////////
