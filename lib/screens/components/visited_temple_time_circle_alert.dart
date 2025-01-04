import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../models/temple_latlng_model.dart';
import '../../utilities/utilities.dart';

class VisitedTempleTimeCircleAlert extends ConsumerStatefulWidget {
  const VisitedTempleTimeCircleAlert(
      {super.key,
      required this.temple,
      required this.geolocStateList,
      this.displayTempMap});

  final TempleInfoModel temple;
  final List<GeolocModel> geolocStateList;
  final bool? displayTempMap;

  @override
  ConsumerState<VisitedTempleTimeCircleAlert> createState() =>
      _VisitedTempleTimeCircleAlertState();
}

class _VisitedTempleTimeCircleAlertState
    extends ConsumerState<VisitedTempleTimeCircleAlert> {
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
              Text(widget.temple.temple),
              Divider(color: Colors.white.withOpacity(0.5), thickness: 5),
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
          list.add(Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 10,
                  // ignore: use_if_null_to_convert_nulls_to_bools
                  backgroundColor: (widget.displayTempMap == true)
                      ? Colors.orangeAccent.withOpacity(0.5)
                      : Colors.green[900]?.withOpacity(0.5),
                ),
                const SizedBox(width: 10),
                Text(element.time),
              ],
            ),
          ));
        }
      }
    }

    return SingleChildScrollView(child: Column(children: list));
  }
}
