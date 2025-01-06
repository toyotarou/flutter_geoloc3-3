import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../controllers/app_params/app_params_notifier.dart';
import '../../controllers/app_params/app_params_response_state.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../models/temple_latlng_model.dart';
import '../../utilities/utilities.dart';

class VisitedTempleTimeCircleAlert extends ConsumerStatefulWidget {
  const VisitedTempleTimeCircleAlert(
      {super.key,
      required this.temple,
      required this.geolocStateList,
      this.displayTempMap,
      required this.date,
      required this.mapController,
      required this.itemScrollController});

  final DateTime date;
  final TempleInfoModel temple;
  final List<GeolocModel> geolocStateList;
  final bool? displayTempMap;
  final MapController mapController;
  final ItemScrollController itemScrollController;

  @override
  ConsumerState<VisitedTempleTimeCircleAlert> createState() => _VisitedTempleTimeCircleAlertState();
}

class _VisitedTempleTimeCircleAlertState extends ConsumerState<VisitedTempleTimeCircleAlert> {
  Utility utility = Utility();

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: displayTempleNearVisitedTime()),
            ],
          ),
        ),
      )),
    );
  }

  ///
  Widget displayTempleNearVisitedTime() {
    final List<Widget> list = <Widget>[];

    String distance = '';

    final AppParamsResponseState appParamState = ref.watch(appParamProvider);

    for (final GeolocModel element in widget.geolocStateList) {
      final String di = utility.calcDistance(
        originLat: widget.temple.latitude.toDouble(),
        originLng: widget.temple.longitude.toDouble(),
        destLat: element.latitude.toDouble(),
        destLng: element.longitude.toDouble(),
      );

      final double dis = di.toDouble() * 1000;

      final List<String> exDis = dis.toString().split('.');

      distance = exDis[0];

      final int? dist = int.tryParse(distance);

      if (dist != null) {
        if (dist <= 100) {
          list.add(
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                // ignore: use_if_null_to_convert_nulls_to_bools
                backgroundColor:
                    (appParamState.selectedTimeGeoloc != null && appParamState.selectedTimeGeoloc!.time == element.time)
                        ? Colors.redAccent.withOpacity(0.5)
                        // ignore: use_if_null_to_convert_nulls_to_bools
                        : (widget.displayTempMap == true)
                            ? Colors.orangeAccent.withOpacity(0.2)
                            : Colors.green[900]?.withOpacity(0.2),
              ),
              onPressed: () {
                ref.read(appParamProvider.notifier).setIsMarkerShow(flag: true);

                ref.read(appParamProvider.notifier).setSelectedTimeGeoloc(
                      geoloc: GeolocModel(
                        id: 0,
                        year: widget.date.yyyymmdd.split('-')[0],
                        month: widget.date.yyyymmdd.split('-')[1],
                        day: widget.date.yyyymmdd.split('-')[2],
                        time: element.time,
                        latitude: element.latitude,
                        longitude: element.longitude,
                      ),
                    );

                widget.mapController.move(
                  LatLng(element.latitude.toDouble(), element.longitude.toDouble()),
                  appParamState.currentZoom,
                );

                final int pos =
                    widget.geolocStateList.indexWhere((GeolocModel element2) => element2.time == element.time);

                widget.itemScrollController.jumpTo(index: pos);
              },
              child: Column(
                children: <Widget>[
                  Text(element.time, style: const TextStyle(color: Colors.white, fontSize: 10)),
                  Container(width: context.screenSize.width),
                ],
              ),
            ),
          );
        }
      }
    }

    return SingleChildScrollView(child: Column(children: list));
  }
}
