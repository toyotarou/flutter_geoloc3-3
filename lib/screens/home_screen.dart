import 'dart:async';
import 'dart:io';

import 'package:background_task/background_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../collections/geoloc.dart';
import '../controllers/calendars/calendars_notifier.dart';
import '../controllers/calendars/calendars_response_state.dart';
import '../controllers/holidays/holidays_notifier.dart';
import '../controllers/holidays/holidays_response_state.dart';
import '../extensions/extensions.dart';
import '../ripository/geolocs_repository.dart';
import '../ripository/isar_repository.dart';
import '../utilities/utilities.dart';
import 'components/daily_geoloc_display_alert.dart';
import 'parts/geoloc_dialog.dart';

@pragma('vm:entry-point')
void backgroundHandler(Location data) {
  // ignore: always_specify_types
  Future(() async {
    GeolocRepository().getRecentOneGeoloc().then((Geoloc? value) async {
      /////////////////////
      final DateTime now = DateTime.now();
      final DateFormat timeFormat = DateFormat('HH:mm:ss');
      final String currentTime = timeFormat.format(now);

      final Geoloc geoloc = Geoloc()
        ..date = DateTime.now().yyyymmdd
        ..time = currentTime
        ..latitude = data.lat.toString()
        ..longitude = data.lng.toString();
      /////////////////////

      bool isInsert = false;

      int secondDiff = 0;

      if (value != null) {
        secondDiff = DateTime.now()
            .difference(
              DateTime(
                value.date.split('-')[0].toInt(),
                value.date.split('-')[1].toInt(),
                value.date.split('-')[2].toInt(),
                value.time.split(':')[0].toInt(),
                value.time.split(':')[1].toInt(),
                value.time.split(':')[2].toInt(),
              ),
            )
            .inSeconds;
      } else {
        /// 初回
        isInsert = true;
      }

      debugPrint(secondDiff.toString());

      if (secondDiff >= 60) {
        isInsert = true;
      }

      if (isInsert) {
        debugPrint('---------');
        debugPrint(DateTime.now().toString());
        debugPrint(data.lat.toString());
        debugPrint(data.lng.toString());
        debugPrint('---------');

        await IsarRepository.configure();
        IsarRepository.isar.writeTxnSync(() => IsarRepository.isar.geolocs.putSync(geoloc));
      }
    });
  });
}

// ignore: must_be_immutable, unreachable_from_main
class HomeScreen extends ConsumerStatefulWidget {
  // ignore: unreachable_from_main
  HomeScreen({super.key, this.baseYm});

  // ignore: unreachable_from_main
  String? baseYm;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String bgText = 'no start';
  String statusText = 'status';
  bool isEnabledEvenIfKilled = true;

  late final StreamSubscription<Location> _bgDisposer;
  late final StreamSubscription<StatusEvent> _statusDisposer;

  DateTime _calendarMonthFirst = DateTime.now();
  final List<String> _youbiList = <String>[
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  List<String> _calendarDays = <String>[];

  Map<String, String> _holidayMap = <String, String>{};

  final Utility _utility = Utility();

  Map<String, int> dateCurrencySumMap = <String, int>{};

  Map<String, int> monthlySpendTimePlaceSumMap = <String, int>{};

  Map<String, Map<String, int>> bankPricePadMap = <String, Map<String, int>>{};
  Map<String, int> bankPriceTotalPadMap = <String, int>{};

  List<String> monthFirstDateList = <String>[];

  Map<String, int> monthlySpendMap = <String, int>{};

  bool baseYmSetFlag = false;

  List<Geoloc>? geolocList = <Geoloc>[];
  Map<String, List<Geoloc>> geolocMap = <String, List<Geoloc>>{};

  ///
  @override
  void initState() {
    super.initState();

    _bgDisposer = BackgroundTask.instance.stream.listen((Location event) {
      final String message = '${DateTime.now()}: ${event.lat}, ${event.lng}';

      debugPrint(message);

      setState(() => bgText = message);
    });

    // ignore: always_specify_types
    Future(() async {
      final PermissionStatus result = await Permission.notification.request();
      debugPrint('notification: $result');
      if (Platform.isAndroid) {
        if (result.isGranted) {
          await BackgroundTask.instance.setAndroidNotification(
            title: 'バックグラウンド処理',
            message: 'バックグラウンド処理を実行中',
          );
        }
      }
    });

    _statusDisposer = BackgroundTask.instance.status.listen((StatusEvent event) {
      final String message = 'status: ${event.status.value}, message: ${event.message}';

      setState(() => statusText = message);
    });
  }

  ///
  @override
  void dispose() {
    _bgDisposer.cancel();
    _statusDisposer.cancel();
    super.dispose();
  }

  ///
  void _init() {
    // _makeMoneyList();
    // _makeBankPriceList();
    //
    // _makeSpendTimePlaceList();
    //
    // _makeBankNameList();
    //
    // _makeSpendItemList();
    //
    // _makeIncomeList();

    _makeGeolocList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    Future(_init);

    if (widget.baseYm != null && !baseYmSetFlag) {
      // ignore: always_specify_types
      Future(() => ref.read(calendarProvider.notifier).setCalendarYearMonth(baseYm: widget.baseYm));

      baseYmSetFlag = true;
    }

    final CalendarsResponseState calendarState = ref.watch(calendarProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(calendarState.baseYearMonth),
            const SizedBox(width: 10),
            IconButton(
              onPressed: _goPrevMonth,
              icon: Icon(Icons.arrow_back_ios, color: Colors.white.withOpacity(0.8), size: 14),
            ),
            IconButton(
              onPressed: (DateTime.now().yyyymm == calendarState.baseYearMonth) ? null : _goNextMonth,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: (DateTime.now().yyyymm == calendarState.baseYearMonth)
                    ? Colors.grey.withOpacity(0.6)
                    : Colors.white.withOpacity(0.8),
                size: 14,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              final bool isRunning = await BackgroundTask.instance.isRunning;

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('isRunning: $isRunning'),
                    action: SnackBarAction(
                      label: 'close',
                      onPressed: () => ScaffoldMessenger.of(context).clearSnackBars(),
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.signal_wifi_statusbar_4_bar),
          ),
          IconButton(
            onPressed: () async {
              final PermissionStatus status = await Permission.location.request();
              final PermissionStatus statusAlways = await Permission.locationAlways.request();

              if (status.isGranted && statusAlways.isGranted) {
                await BackgroundTask.instance.start(isEnabledEvenIfKilled: isEnabledEvenIfKilled);
                setState(() => bgText = 'start');
              }
            },
            icon: const Icon(Icons.play_arrow),
          ),
        ],
      ),
      body: Column(children: <Widget>[Expanded(child: _getCalendar())]),
    );
  }

  Widget _getCalendar() {
    monthlySpendMap = <String, int>{};

    final HolidaysResponseState holidayState = ref.watch(holidayProvider);

    if (holidayState.holidayMap.value != null) {
      _holidayMap = holidayState.holidayMap.value!;
    }

    final CalendarsResponseState calendarState = ref.watch(calendarProvider);

    _calendarMonthFirst = DateTime.parse('${calendarState.baseYearMonth}-01 00:00:00');

    final DateTime monthEnd = DateTime.parse('${calendarState.nextYearMonth}-00 00:00:00');

    final int diff = monthEnd.difference(_calendarMonthFirst).inDays;
    final int monthDaysNum = diff + 1;

    final String youbi = _calendarMonthFirst.youbiStr;
    final int youbiNum = _youbiList.indexWhere((String element) => element == youbi);

    final int weekNum = ((monthDaysNum + youbiNum) <= 35) ? 5 : 6;

    // ignore: always_specify_types
    _calendarDays = List.generate(weekNum * 7, (int index) => '');

    for (int i = 0; i < (weekNum * 7); i++) {
      if (i >= youbiNum) {
        final DateTime gendate = _calendarMonthFirst.add(Duration(days: i - youbiNum));

        if (_calendarMonthFirst.month == gendate.month) {
          _calendarDays[i] = gendate.day.toString();
        }
      }
    }

    final List<Widget> list = <Widget>[];
    for (int i = 0; i < weekNum; i++) {
      list.add(_getCalendarRow(week: i));
    }

    return DefaultTextStyle(style: const TextStyle(fontSize: 10), child: Column(children: list));
  }

  ///
  Widget _getCalendarRow({required int week}) {
    final List<Widget> list = <Widget>[];

    for (int i = week * 7; i < ((week + 1) * 7); i++) {
      final String generateYmd = (_calendarDays[i] == '')
          ? ''
          : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month, _calendarDays[i].toInt()).yyyymmdd;

      final String youbiStr = (_calendarDays[i] == '')
          ? ''
          : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month, _calendarDays[i].toInt()).youbiStr;

      list.add(
        Expanded(
          child: GestureDetector(
            // onTap: (_calendarDays[i] == '')
            //     ? null
            //     : (DateTime.parse('$generateYmd 00:00:00').isAfter(DateTime.now()))
            //         ? null
            //         : () {
            //             GeolocDialog(
            //               context: context,
            //               widget: DailyGeolocDisplayAlert(date: DateTime.parse('$generateYmd 00:00:00')),
            //             );
            //           },
            child: Container(
              margin: const EdgeInsets.all(1),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: (_calendarDays[i] == '')
                      ? Colors.transparent
                      : (generateYmd == DateTime.now().yyyymmdd)
                          ? Colors.orangeAccent.withOpacity(0.4)
                          : Colors.white.withOpacity(0.1),
                  width: 3,
                ),
                color: (_calendarDays[i] == '')
                    ? Colors.transparent
                    : (DateTime.parse('$generateYmd 00:00:00').isAfter(DateTime.now()))
                        ? Colors.white.withOpacity(0.1)
                        : _utility.getYoubiColor(date: generateYmd, youbiStr: youbiStr, holidayMap: _holidayMap),
              ),
              child: (_calendarDays[i] == '')
                  ? const Text('')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[Text(_calendarDays[i].padLeft(2, '0')), Container()],
                        ),
                        const SizedBox(height: 5),
                        ConstrainedBox(
                          constraints: BoxConstraints(minHeight: context.screenSize.height / 10),
                          child: Column(
                            children: <Widget>[
                              //---------------------------------------//

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  if (_calendarDays[i] != '' &&
                                      DateTime.parse('$generateYmd 00:00:00').isBefore(DateTime.now())) ...<Widget>[
                                    if (geolocMap[generateYmd] == null) ...<Widget>[Container()],
                                    if (geolocMap[generateYmd] != null) ...<Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          GeolocDialog(
                                            context: context,
                                            widget:
                                                DailyGeolocDisplayAlert(date: DateTime.parse('$generateYmd 00:00:00')),
                                          );
                                        },
                                        child: Icon(Icons.info_outline, size: 14, color: Colors.white.withOpacity(0.4)),
                                      ),
                                    ],
                                  ],
                                  Text(geolocMap[generateYmd]?.length.toString() ?? ''),
                                ],
                              ),

                              //---------------------------------------//
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
    }

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: list);
  }

  ///
  void _goPrevMonth() {
    final CalendarsResponseState calendarState = ref.watch(calendarProvider);

    Navigator.pushReplacement(
      context,
      // ignore: inference_failure_on_instance_creation, always_specify_types
      MaterialPageRoute(builder: (BuildContext context) => HomeScreen(baseYm: calendarState.prevYearMonth)),
    );
  }

  ///
  void _goNextMonth() {
    final CalendarsResponseState calendarState = ref.watch(calendarProvider);

    Navigator.pushReplacement(
      context,
      // ignore: inference_failure_on_instance_creation, always_specify_types
      MaterialPageRoute(builder: (BuildContext context) => HomeScreen(baseYm: calendarState.nextYearMonth)),
    );
  }

  ///
  Future<void> _makeGeolocList() async {
    GeolocRepository().getAllGeoloc().then((List<Geoloc>? value) {
      if (mounted) {
        setState(() {
          geolocList = value;

          if (value!.isNotEmpty) {
            for (final Geoloc element in value) {
              geolocMap[element.date] = <Geoloc>[];
            }

            for (final Geoloc element in value) {
              geolocMap[element.date]?.add(element);
            }
          }
        });
      }
    });
  }
}
