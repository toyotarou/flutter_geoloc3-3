import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';

import '../../extensions/extensions.dart';
import '../../models/temple_latlng_model.dart';

class VisitedTempleDisplayAlert extends StatefulWidget {
  const VisitedTempleDisplayAlert({super.key, required this.templeInfoMap, required this.mapController});

  final List<TempleInfoModel> templeInfoMap;
  final MapController mapController;

  @override
  State<VisitedTempleDisplayAlert> createState() => _VisitedTempleDisplayAlertState();
}

class _VisitedTempleDisplayAlertState extends State<VisitedTempleDisplayAlert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              widget.mapController.move(
                LatLng(
                  widget.templeInfoMap[0].latitude.toDouble(),
                  widget.templeInfoMap[0].longitude.toDouble(),
                ),
                18,
              );
            },
            child: const Text('aaa'),
          ),
        ],
      )),
    );
  }
}
