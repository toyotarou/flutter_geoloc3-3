import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../utilities/tile_provider.dart';

class DailyGeolocMapAlert extends ConsumerStatefulWidget {
  const DailyGeolocMapAlert({super.key, required this.geolocStateList});

  final List<GeolocModel> geolocStateList;

  @override
  ConsumerState<DailyGeolocMapAlert> createState() => _DailyGeolocMapAlertState();
}

class _DailyGeolocMapAlertState extends ConsumerState<DailyGeolocMapAlert> {
  List<double> latList = <double>[];
  List<double> lngList = <double>[];

  double minLat = 0.0;
  double maxLat = 0.0;
  double minLng = 0.0;
  double maxLng = 0.0;

  final MapController mapController = MapController();

  List<Marker> markerList = <Marker>[];

  ///
  @override
  Widget build(BuildContext context) {
    makeMinMaxLatLng();

    makeMarker();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: LatLng(minLat, minLng),
                    initialCameraFit: ((minLat == maxLat) && (minLng == maxLng))
                        ? null
                        : CameraFit.bounds(
                            bounds: LatLngBounds.fromPoints(
                              <LatLng>[LatLng(minLat, maxLng), LatLng(maxLat, minLng)],
                            ),
                            padding: const EdgeInsets.all(50),
                          ),
                  ),
                  children: <Widget>[
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      tileProvider: CachedTileProvider(),
                      userAgentPackageName: 'com.example.app',
                    ),

                    MarkerLayer(markers: markerList),

                    // // ignore: always_specify_types
                    // PolylineLayer(
                    //   polylines: <Polyline<Object>>[
                    //     // ignore: always_specify_types
                    //     Polyline(
                    //       points: widget.geolocStateList.map((GeolocModel e) {
                    //         return LatLng(
                    //           e.latitude.toDouble(),
                    //           e.longitude.toDouble(),
                    //         );
                    //       }).toList(),
                    //       color: Colors.redAccent,
                    //       strokeWidth: 5,
                    //     ),
                    //   ],
                    // ),
                    //
                    //
                    //
                  ],
                )),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            child: displayTimeCircleAvatar(),
          ),
        ],
      ),
    );
  }

  ///
  void makeMinMaxLatLng() {
    for (final GeolocModel element in widget.geolocStateList) {
      latList.add(element.latitude.toDouble());
      lngList.add(element.longitude.toDouble());
    }

    if (latList.isNotEmpty && lngList.isNotEmpty) {
      minLat = latList.reduce(min);
      maxLat = latList.reduce(max);
      minLng = lngList.reduce(min);
      maxLng = lngList.reduce(max);
    }
  }

  ///
  void makeMarker() {
    markerList = <Marker>[];

    for (int i = 0; i < widget.geolocStateList.length; i++) {
      markerList.add(
        Marker(
          point: LatLng(
            widget.geolocStateList[i].latitude.toDouble(),
            widget.geolocStateList[i].longitude.toDouble(),
          ),
          width: 40,
          height: 40,
          child: CircleAvatar(
            backgroundColor: Colors.green[900]?.withOpacity(0.5),
            child: Text(
              widget.geolocStateList[i].time,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      );
    }
  }

  ///
  Widget displayTimeCircleAvatar() {
    final List<Widget> list = <Widget>[];

    for (final GeolocModel element in widget.geolocStateList) {
      list.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CircleAvatar(
            backgroundColor: Colors.green[900]?.withOpacity(0.5),
            child: Text(
              element.time,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      );
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
