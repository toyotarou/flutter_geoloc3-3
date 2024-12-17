import 'package:flutter/material.dart';

import '../../collections/geoloc.dart';
import '../../extensions/extensions.dart';

class PickupGeolocDisplayAlert extends StatefulWidget {
  const PickupGeolocDisplayAlert({super.key, required this.pickupGeolocList, required this.date});

  final DateTime date;
  final List<Geoloc> pickupGeolocList;

  @override
  State<PickupGeolocDisplayAlert> createState() => _PickupGeolocDisplayAlertState();
}

class _PickupGeolocDisplayAlertState extends State<PickupGeolocDisplayAlert> {
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
                  onTap: () {},
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
}
