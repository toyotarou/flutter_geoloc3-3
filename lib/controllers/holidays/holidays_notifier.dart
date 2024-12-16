import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';

import '../../models/holiday.dart';
import 'holidays_response_state.dart';

final AutoDisposeStateNotifierProvider<HolidayNotifier, HolidaysResponseState>
    holidayProvider =
    StateNotifierProvider.autoDispose<HolidayNotifier, HolidaysResponseState>(
        (AutoDisposeStateNotifierProviderRef<HolidayNotifier,
                HolidaysResponseState>
            ref) {
  return HolidayNotifier(const HolidaysResponseState())..getHoliday();
});

class HolidayNotifier extends StateNotifier<HolidaysResponseState> {
  HolidayNotifier(super.state);

  Future<void> getHoliday() async {
    try {
      const String url = 'https://holidays-jp.github.io/api/v1/date.json';

      final Response response = await get(Uri.parse(url));

      final Map<String, String> holiday = holidayFromJson(response.body);

      // ignore: always_specify_types
      state = state.copyWith(holidayMap: AsyncValue.data(holiday));
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      // ignore: only_throw_errors
      throw e.toString();
    }
  }
}
