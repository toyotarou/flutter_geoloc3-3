import 'package:flutter/material.dart';

import '../../collections/geoloc.dart';

import '../../extensions/extensions.dart';
import '../../ripository/geolocs_repository.dart';
import '../parts/geoloc_dialog.dart';
import 'pickup_geoloc_display_alert.dart';

class DailyGeolocDisplayAlert extends StatefulWidget {
  const DailyGeolocDisplayAlert({super.key, required this.date});

  final DateTime date;

  @override
  State<DailyGeolocDisplayAlert> createState() => _DailyGeolocDisplayAlertState();
}

class _DailyGeolocDisplayAlertState extends State<DailyGeolocDisplayAlert> {
  List<Geoloc>? geolocList = <Geoloc>[];
  List<Geoloc>? reverseGeolocList = <Geoloc>[];

  List<Geoloc> pickupGeolocList = <Geoloc>[];

  String diffSeconds = '';

  ///
  void _init() {
    _makeGeolocList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    Future(_init);

    makeDiffSeconds();

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
                  onTap: () async {
                    await makeReverseGeolocList();

                    GeolocDialog(
                      // ignore: use_build_context_synchronously
                      context: context,
                      widget: PickupGeolocDisplayAlert(date: widget.date, pickupGeolocList: pickupGeolocList),
                    );
                  },
                  child: const Icon(Icons.list),
                ),
              ],
            ),
            Divider(color: Colors.white.withOpacity(0.5), thickness: 5),
            Expanded(child: displayGeolocList()),
            Divider(color: Colors.white.withOpacity(0.5), thickness: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Container(), Text(diffSeconds)],
            ),
          ],
        ),
      )),
    );
  }

  ///
  Future<void> _makeGeolocList() async {
    GeolocRepository().getAllGeoloc().then((List<Geoloc>? value) {
      if (mounted) {
        setState(() {
          geolocList = value;
          reverseGeolocList = value;
        });
      }
    });
  }

  ///
  Widget displayGeolocList() {
    final List<Widget> list = <Widget>[];

    geolocList?.forEach((Geoloc element) {
      if (widget.date.yyyymmdd == element.date) {
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
    });

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

  Future<void> makeReverseGeolocList() async {
    if (reverseGeolocList != null) {
      pickupGeolocList = <Geoloc>[];
      final List<String> latLngList = <String>[];

      reverseGeolocList!.sort((Geoloc a, Geoloc b) => a.time.compareTo(b.time));

      for (var i = 0; i < reverseGeolocList!.length; i++) {
        var value = reverseGeolocList![i];

        if (value.date == widget.date.yyyymmdd) {
          if (!latLngList.contains('${value.latitude}|${value.longitude}')) {
            pickupGeolocList.add(value);
          }

          latLngList.add('${value.latitude}|${value.longitude}');
        }
      }
    }
  }

  ///
  void makeDiffSeconds() {
    GeolocRepository().getRecentOneGeoloc().then((Geoloc? value) {
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
      }

      diffSeconds = secondDiff.toString().padLeft(2, '0');
    });
  }
}
