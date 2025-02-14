import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_params/app_params_notifier.dart';
import 'app_params/app_params_response_state.dart';
import 'calendars/calendars_notifier.dart';
import 'calendars/calendars_response_state.dart';
import 'geoloc/geoloc.dart';
import 'holidays/holidays_notifier.dart';
import 'holidays/holidays_response_state.dart';
import 'temple/temple.dart';
import 'temple_photo/temple_photo_notifier.dart';
import 'temple_photo/temple_photo_response_state.dart';
import 'walk_record/walk_record.dart';

mixin ControllersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  //==========================================//

  AppParamsResponseState get appParamState => ref.watch(appParamProvider);

  AppParamNotifier get appParamNotifier => ref.read(appParamProvider.notifier);

//==========================================//

  CalendarsResponseState get calendarState => ref.watch(calendarProvider);

  CalendarNotifier get calendarNotifier => ref.read(calendarProvider.notifier);

//==========================================//

  GeolocControllerState get geolocState => ref.watch(geolocControllerProvider);

  GeolocController get geolocNotifier => ref.read(geolocControllerProvider.notifier);

//==========================================//

  HolidaysResponseState get holidaysState => ref.watch(holidayProvider);

  HolidayNotifier get holidayNotifier => ref.read(holidayProvider.notifier);

//==========================================//

  TempleControllerState get templeState => ref.watch(templeControllerProvider);

  TempleController get templeNotifier => ref.read(templeControllerProvider.notifier);

//==========================================//

  TemplePhotoResponseState get templePhotoState => ref.watch(templePhotoProvider);

  TemplePhotoNotifier get templePhotoNotifier => ref.read(templePhotoProvider.notifier);

//==========================================//

  WalkRecordControllerState get walkRecordState => ref.watch(walkRecordControllerProvider);

  WalkRecordController get walkRecordNotifier => ref.read(walkRecordControllerProvider.notifier);

//==========================================//
}
