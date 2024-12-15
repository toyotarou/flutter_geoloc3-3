import 'package:flutter/material.dart';

import '../../collections/geoloc.dart';
import '../../ripository/geolocs_repository.dart';

class DummyGeolocAlert extends StatefulWidget {
  const DummyGeolocAlert({super.key});

  @override
  State<DummyGeolocAlert> createState() => _DummyGeolocAlertState();
}

class _DummyGeolocAlertState extends State<DummyGeolocAlert> {
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
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(child: displayGeolocList()),
        ],
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
      list.add(Row(
        children: <Widget>[
          Expanded(child: Text(element.date)),
          Expanded(child: Text(element.time)),
          Expanded(child: Text(element.latitude)),
          Expanded(child: Text(element.longitude)),
        ],
      ));
    });

    return SingleChildScrollView(
      child: Column(children: list),
    );
  }
}
