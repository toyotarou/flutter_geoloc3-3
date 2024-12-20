import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../collections/geoloc.dart';
import '../../controllers/geoloc/geoloc.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../utilities/utilities.dart';
import '../home_screen.dart';
import '../parts/geoloc_dialog.dart';
import 'daily_geoloc_map_alert.dart';

class PickupGeolocDisplayAlert extends ConsumerStatefulWidget {
  const PickupGeolocDisplayAlert({super.key, required this.pickupGeolocList, required this.date});

  final DateTime date;
  final List<Geoloc> pickupGeolocList;

  @override
  ConsumerState<PickupGeolocDisplayAlert> createState() => _PickupGeolocDisplayAlertState();
}

class _PickupGeolocDisplayAlertState extends ConsumerState<PickupGeolocDisplayAlert> {
  Utility utility = Utility();

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
            Container(width: context.screenSize.width),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(widget.date.yyyymmdd),
                Row(
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          final List<GeolocModel> list = <GeolocModel>[];
                          for (final Geoloc element in widget.pickupGeolocList) {
                            list.add(
                              GeolocModel(
                                id: 0,
                                year: element.date.split('-')[0],
                                month: element.date.split('-')[1],
                                day: element.date.split('-')[2],
                                time: element.time,
                                latitude: element.latitude,
                                longitude: element.longitude,
                              ),
                            );
                          }

                          GeolocDialog(
                            context: context,
                            widget: DailyGeolocMapAlert(geolocStateList: list, displayTempMap: true),
                          );
                        },
                        child: const Icon(Icons.map, color: Colors.orangeAccent)),
                    const SizedBox(width: 30),
                    GestureDetector(onTap: () => deletePickupGeoloc(), child: const Icon(Icons.delete)),
                    const SizedBox(width: 30),
                    GestureDetector(onTap: () => inputPickupGeoloc(), child: const Icon(Icons.input)),
                  ],
                ),
              ],
            ),
            Divider(color: Colors.white.withOpacity(0.5), thickness: 5),
            Expanded(child: displayPickupGeolocList()),
            Divider(color: Colors.white.withOpacity(0.5), thickness: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Container(), Text(widget.pickupGeolocList.length.toString())],
            ),
          ],
        ),
      )),
    );
  }

  ///
  Widget displayPickupGeolocList() {
    final List<Widget> list = <Widget>[];

    int i = 0;
    String keepLat = '';
    String keepLng = '';
    for (final Geoloc element in widget.pickupGeolocList) {
      String distance = '';
      if (i == 0) {
        distance = '0';
      } else {
        final String di = utility.calcDistance(
          originLat: keepLat.toDouble(),
          originLng: keepLng.toDouble(),
          destLat: element.latitude.toDouble(),
          destLng: element.longitude.toDouble(),
        );

        final double dis = di.toDouble() * 1000;

        final List<String> exDis = dis.toString().split('.');

        distance = exDis[0];
      }

      list.add(DefaultTextStyle(
        style: const TextStyle(fontSize: 12),
        child: Row(
          children: <Widget>[
            Expanded(child: Text(element.time)),
            Expanded(flex: 2, child: Container(alignment: Alignment.topRight, child: Text(element.latitude))),
            Expanded(flex: 2, child: Container(alignment: Alignment.topRight, child: Text(element.longitude))),
            Expanded(child: Container(alignment: Alignment.topRight, child: Text('$distance m'))),
          ],
        ),
      ));

      keepLat = element.latitude;
      keepLng = element.longitude;
      i++;
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
  Future<void> deletePickupGeoloc() async {
    // ignore: always_specify_types
    ref.read(geolocControllerProvider.notifier).deleteGeoloc(date: widget.date.yyyymmdd).then((value) {
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);

        Navigator.pushReplacement(
          context,
          // ignore: inference_failure_on_instance_creation, always_specify_types
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(baseYm: widget.date.yyyymm),
          ),
        );
      }
    });
  }

  ///
  Future<void> inputPickupGeoloc() async {
    widget.pickupGeolocList
      ..sort((Geoloc a, Geoloc b) => a.time.compareTo(b.time))
      ..forEach((Geoloc element) async {
        final Map<String, String> map = <String, String>{
          'year': element.date.split('-')[0],
          'month': element.date.split('-')[1],
          'day': element.date.split('-')[2],
          'time': element.time,
          'latitude': element.latitude,
          'longitude': element.longitude,
        };

        await ref.read(geolocControllerProvider.notifier).inputGeoloc(map: map);
      });

    if (mounted) {
      Navigator.pop(context);
      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        // ignore: inference_failure_on_instance_creation, always_specify_types
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(baseYm: widget.date.yyyymm),
        ),
      );
    }
  }
}
