import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/geoloc/geoloc.dart';
import '../../extensions/extensions.dart';
import '../home_screen.dart';

class HistoryGeolocListAlert extends ConsumerStatefulWidget {
  const HistoryGeolocListAlert({super.key});

  @override
  ConsumerState<HistoryGeolocListAlert> createState() => _HistoryGeolocListAlertState();
}

class _HistoryGeolocListAlertState extends ConsumerState<HistoryGeolocListAlert> {
  ///
  @override
  void initState() {
    super.initState();

    ref.read(geolocControllerProvider.notifier).getOldestGeoloc();

    ref.read(geolocControllerProvider.notifier).getRecentGeoloc();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(child: displayHistoryGeolocYearMonthList()),
          ],
        ),
      )),
    );
  }

  ///
  Widget displayHistoryGeolocYearMonthList() {
    final List<Widget> list = <Widget>[];

    final GeolocControllerState geolocControllerState = ref.watch(geolocControllerProvider);

    if (geolocControllerState.oldestGeolocModel != null) {
      if (geolocControllerState.recentGeolocList.isNotEmpty) {
        final DateTime startDate = DateTime(
          geolocControllerState.oldestGeolocModel!.year.toInt(),
          geolocControllerState.oldestGeolocModel!.month.toInt(),
          geolocControllerState.oldestGeolocModel!.day.toInt(),
        );

        final DateTime endDate = DateTime(
          geolocControllerState.recentGeolocList[0].year.toInt(),
          geolocControllerState.recentGeolocList[0].month.toInt(),
          geolocControllerState.recentGeolocList[0].day.toInt(),
        );

        final List<DateTime> dateList = generateDateList(startDate, endDate);

        final List<String> yearmonth = <String>[];
        for (final DateTime date in dateList) {
          if (!yearmonth.contains(date.yyyymm)) {
            list.add(Container(
              padding: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
              ),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.pushReplacement(
                        context,
                        // ignore: inference_failure_on_instance_creation, always_specify_types
                        MaterialPageRoute(builder: (BuildContext context) => HomeScreen(baseYm: date.yyyymm)),
                      );
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      child: const Text('', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(date.yyyymm),
                ],
              ),
            ));
          }

          yearmonth.add(date.yyyymm);
        }
      }
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => list[index],
            childCount: list.length,
          ),
        ),
      ],
    );
  }

  ///
  List<DateTime> generateDateList(DateTime startDate, DateTime endDate) {
    final List<DateTime> dates = <DateTime>[];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      dates.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1)); // 1日ずつ増やす
    }

    return dates;
  }
}
