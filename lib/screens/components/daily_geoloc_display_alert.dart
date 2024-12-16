import 'package:flutter/material.dart';

import '../../collections/geoloc.dart';

import '../../extensions/extensions.dart';
import '../../ripository/geolocs_repository.dart';

class DailyGeolocDisplayAlert extends StatefulWidget {
  const DailyGeolocDisplayAlert({super.key, required this.date});

  final DateTime date;

  @override
  State<DailyGeolocDisplayAlert> createState() => _DailyGeolocDisplayAlertState();
}

class _DailyGeolocDisplayAlertState extends State<DailyGeolocDisplayAlert> {
  List<Geoloc>? geolocList = <Geoloc>[];

  ///
  void _init() {
    _makeGeolocList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    Future(_init);

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
              children: <Widget>[Text(widget.date.yyyymmdd), Container()],
            ),
            Divider(color: Colors.white.withOpacity(0.5), thickness: 5),
            Expanded(child: displayGeolocList()),
          ],
        ),
      )),
    );
  }

  ///
  Future<void> _makeGeolocList() async {
    GeolocRepository().getAllGeoloc().then((List<Geoloc>? value) {
      if (mounted) {
        setState(() => geolocList = value);
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

    return SingleChildScrollView(
      child: Column(children: list),
    );
  }
}
