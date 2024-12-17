import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../collections/geoloc.dart';
import '../../controllers/geoloc/geoloc.dart';
import '../../extensions/extensions.dart';

class PickupGeolocDisplayAlert extends ConsumerStatefulWidget {
  const PickupGeolocDisplayAlert({super.key, required this.pickupGeolocList, required this.date});

  final DateTime date;
  final List<Geoloc> pickupGeolocList;

  @override
  ConsumerState<PickupGeolocDisplayAlert> createState() => _PickupGeolocDisplayAlertState();
}

class _PickupGeolocDisplayAlertState extends ConsumerState<PickupGeolocDisplayAlert> {
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
                GestureDetector(
                  onTap: () {
                    inputPickupGeoloc();
                  },
                  child: const Icon(Icons.input),
                ),
              ],
            ),
            Divider(color: Colors.white.withOpacity(0.5), thickness: 5),
            Expanded(child: displayPickupGeolocList()),
          ],
        ),
      )),
    );
  }

  ///
  Widget displayPickupGeolocList() {
    final List<Widget> list = <Widget>[];

    for (final Geoloc element in widget.pickupGeolocList) {
      list.add(DefaultTextStyle(
        style: const TextStyle(fontSize: 12),
        child: Row(
          children: <Widget>[
            Expanded(child: Text(element.time)),
            Expanded(child: Container(alignment: Alignment.topRight, child: Text(element.latitude))),
            Expanded(child: Container(alignment: Alignment.topRight, child: Text(element.longitude))),
          ],
        ),
      ));
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

    Navigator.pop(context);
    Navigator.pop(context);
  }
}
