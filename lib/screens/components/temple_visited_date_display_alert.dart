import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/app_params/app_params_notifier.dart';
import '../../controllers/geoloc/geoloc.dart';
import '../../controllers/temple/temple.dart';
import '../../controllers/walk_record/walk_record.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../models/temple_latlng_model.dart';
import '../../models/walk_record_model.dart';
import '../parts/geoloc_dialog.dart';
import 'geoloc_map_alert.dart';

class TempleVisitedDateDisplayAlert extends ConsumerStatefulWidget {
  const TempleVisitedDateDisplayAlert({super.key});

  @override
  ConsumerState<TempleVisitedDateDisplayAlert> createState() => _TempleVisitedDateDisplayAlertState();
}

class _TempleVisitedDateDisplayAlertState extends ConsumerState<TempleVisitedDateDisplayAlert> {
  ///
  @override
  void initState() {
    super.initState();

    ref.read(geolocControllerProvider.notifier).getAllGeoloc();
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
              Expanded(child: displayTempleVisitedDateList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayTempleVisitedDateList() {
    final List<Widget> list = <Widget>[];

    final Map<String, List<String>> yearVisitedDateMap =
        ref.watch(templeControllerProvider.select((TempleControllerState value) => value.yearVisitedDateMap));

    final Map<String, List<TempleInfoModel>> templeInfoMap =
        ref.watch(templeControllerProvider.select((TempleControllerState value) => value.templeInfoMap));

    final Map<String, WalkRecordModel> walkRecordMap =
        ref.watch(walkRecordControllerProvider.select((WalkRecordControllerState value) => value.walkRecordMap));

    final Map<String, List<GeolocModel>> allGeolocMap =
        ref.watch(geolocControllerProvider.select((GeolocControllerState value) => value.allGeolocMap));

    yearVisitedDateMap.forEach(
      (String year, List<String> value) {
        if (year.toInt() >= 2023) {
          final List<Widget> list2 = <Widget>[];

          for (final String date in value) {
            if (DateTime.parse('$date 00:00:00').isAfter(DateTime(2023, 4, 13))) {
              list2.add(
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          ref.read(appParamProvider.notifier).setIsMarkerShow(flag: false);

                          GeolocDialog(
                            context: context,
                            widget: GeolocMapAlert(
                              date: DateTime.parse('$date 00:00:00'),
                              geolocStateList: allGeolocMap[date] ?? <GeolocModel>[],
                              displayMonthMap: false,
                              walkRecord: walkRecordMap[date] ??
                                  WalkRecordModel(id: 0, year: '', month: '', day: '', step: 0, distance: 0),
                              templeInfoList: templeInfoMap[date],
                            ),
                            executeFunctionWhenDialogClose: true,
                            ref: ref,
                          );
                        },
                        child: CircleAvatar(radius: 12, backgroundColor: Colors.white.withOpacity(0.2)),
                      ),
                      const SizedBox(width: 10),
                      Text(date),
                    ],
                  ),
                ),
              );

              if (templeInfoMap[date] != null) {
                list2.add(
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: templeInfoMap[date]!.map(
                        (TempleInfoModel e) {
                          return Container(
                            width: 120,
                            height: 60,
                            margin: const EdgeInsets.all(3),
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.2))),
                            child: Text(e.temple, maxLines: 3, overflow: TextOverflow.ellipsis),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                );
              }

              list2.add(const SizedBox(height: 10));
            }
          }

          list.add(
            Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text(year), Container()],
                  ),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: list2),
              ],
            ),
          );
        }
      },
    );

    return SingleChildScrollView(
      child: DefaultTextStyle(style: const TextStyle(fontSize: 12), child: Column(children: list)),
    );
  }
}
