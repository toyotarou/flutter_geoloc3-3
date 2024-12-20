import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/app_params/app_params_notifier.dart';
import '../../controllers/app_params/app_params_response_state.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../utilities/tile_provider.dart';

class DailyGeolocMapAlert extends ConsumerStatefulWidget {
  const DailyGeolocMapAlert({super.key, required this.geolocStateList, this.displayTempMap});

  final List<GeolocModel> geolocStateList;

  final bool? displayTempMap;

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
                      initialCameraFit: CameraFit.bounds(
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
                  ),
                ),
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

    final GeolocModel? selectedTimeGeoloc =
        ref.watch(appParamProvider.select((AppParamsResponseState value) => value.selectedTimeGeoloc));

    for (final GeolocModel element in widget.geolocStateList) {
      markerList.add(
        Marker(
          point: LatLng(element.latitude.toDouble(), element.longitude.toDouble()),
          width: 40,
          height: 40,
          child: CircleAvatar(
            // ignore: use_if_null_to_convert_nulls_to_bools
            backgroundColor: (selectedTimeGeoloc != null && selectedTimeGeoloc.time == element.time)
                ? Colors.redAccent.withOpacity(0.5)
                // ignore: use_if_null_to_convert_nulls_to_bools
                : (widget.displayTempMap == true)
                    ? Colors.orangeAccent.withOpacity(0.5)
                    : Colors.green[900]?.withOpacity(0.5),
            child: Text(
              element.time,
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

    final GeolocModel? selectedTimeGeoloc =
        ref.watch(appParamProvider.select((AppParamsResponseState value) => value.selectedTimeGeoloc));

    for (final GeolocModel element in widget.geolocStateList) {
      list.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () {
              ref.read(appParamProvider.notifier).setSelectedTimeGeoloc(geoloc: element);

              mapController.move(LatLng(element.latitude.toDouble(), element.longitude.toDouble()), 18);
            },
            child: CircleAvatar(
              // ignore: use_if_null_to_convert_nulls_to_bools
              backgroundColor: (selectedTimeGeoloc != null && selectedTimeGeoloc.time == element.time)
                  ? Colors.redAccent.withOpacity(0.5)
                  // ignore: use_if_null_to_convert_nulls_to_bools
                  : (widget.displayTempMap == true)
                      ? Colors.orangeAccent.withOpacity(0.5)
                      : Colors.green[900]?.withOpacity(0.5),
              child: Text(
                element.time,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
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
