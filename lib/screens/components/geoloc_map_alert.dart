import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/app_params/app_params_notifier.dart';
import '../../controllers/app_params/app_params_response_state.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../models/temple_latlng_model.dart';
import '../../models/walk_record_model.dart';
import '../../utilities/tile_provider.dart';
import '../parts/geoloc_dialog.dart';
import 'geoloc_map_control_panel_alert.dart';

class GeolocMapAlert extends ConsumerStatefulWidget {
  const GeolocMapAlert(
      {super.key,
      required this.geolocStateList,
      this.displayTempMap,
      required this.displayMonthMap,
      required this.walkRecord,
      this.templeInfoList,
      required this.date});

  final DateTime date;
  final List<GeolocModel> geolocStateList;
  final bool? displayTempMap;
  final bool displayMonthMap;
  final WalkRecordModel walkRecord;
  final List<TempleInfoModel>? templeInfoList;

  @override
  ConsumerState<GeolocMapAlert> createState() => _GeolocMapAlertState();
}

class _GeolocMapAlertState extends ConsumerState<GeolocMapAlert> {
  List<double> latList = <double>[];
  List<double> lngList = <double>[];

  double minLat = 0.0;
  double maxLat = 0.0;
  double minLng = 0.0;
  double maxLng = 0.0;

  final MapController mapController = MapController();

  List<Marker> markerList = <Marker>[];

  late ScrollController scrollController;

  List<GeolocModel> polylineGeolocList = <GeolocModel>[];

  Map<String, List<String>> selectedHourMap = <String, List<String>>{};

  double? currentZoom;

  double currentZoomEightTeen = 18;

  final double circleRadiusMeters = 100.0;

  bool isLoading = false;

  ///
  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => isLoading = true);

      // ignore: always_specify_types
      Future.delayed(const Duration(seconds: 2), () {
        setDefaultBoundsMap();

        setState(() {
          isLoading = false;
        });
      });
    });
  }

  ///
  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  // ///
  // void _scrollToTop() {
  //   _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  // }

  bool getBoundsZoomValue = false;

  ///
  @override
  Widget build(BuildContext context) {
    makeSelectedHourMap();

    makeMinMaxLatLng();

    makeMarker();

    if (!getBoundsZoomValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) async => setDefaultBoundsMap());
    }

    final AppParamsResponseState appParamState = ref.watch(appParamProvider);

    polylineGeolocList = (!appParamState.isMarkerShow) ? widget.geolocStateList : <GeolocModel>[];

    if (appParamState.polylineGeolocModel != null) {
      makePolylineGeolocList(geoloc: appParamState.polylineGeolocModel!);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter:
                  LatLng(widget.geolocStateList[0].latitude.toDouble(), widget.geolocStateList[0].longitude.toDouble()),
              initialZoom: currentZoomEightTeen,
              onPositionChanged: (MapCamera position, bool isMoving) {
                if (isMoving) {
                  ref.read(appParamProvider.notifier).setCurrentZoom(zoom: position.zoom);
                }
              },
            ),
            children: <Widget>[
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: CachedTileProvider(),
                userAgentPackageName: 'com.example.app',
              ),

              if (appParamState.isMarkerShow) ...<Widget>[MarkerLayer(markers: markerList)],

              // ignore: always_specify_types
              PolylineLayer(
                polylines: <Polyline<Object>>[
                  // ignore: always_specify_types
                  Polyline(
                    points: polylineGeolocList
                        .map((GeolocModel e) => LatLng(e.latitude.toDouble(), e.longitude.toDouble()))
                        .toList(),
                    color: Colors.redAccent,
                    strokeWidth: 5,
                  ),
                ],
              ),

              if (appParamState.isTempleCircleShow && appParamState.currentCenter != null)
                // ignore: always_specify_types
                PolygonLayer(
                  polygons: <Polygon<Object>>[
                    // ignore: always_specify_types
                    Polygon(
                      points: calculateCirclePoints(appParamState.currentCenter!, circleRadiusMeters),
                      color: Colors.redAccent.withOpacity(0.1),
                      borderStrokeWidth: 2.0,
                      borderColor: Colors.redAccent.withOpacity(0.5),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            left: 5,
            child: Column(
              children: <Widget>[
                Container(
                  width: context.screenSize.width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 100,
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(widget.date.yyyymmdd),
                                if (appParamState.selectedTimeGeoloc != null) ...<Widget>[
                                  Text(
                                    appParamState.selectedTimeGeoloc!.time,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      const SizedBox(width: 70, child: Text('size: ')),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            appParamState.currentZoom.toStringAsFixed(2),
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      const SizedBox(width: 70, child: Text('padding: ')),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            '${appParamState.currentPaddingIndex * 10} px',
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                              child: IconButton(
                                onPressed: () {
                                  GeolocDialog(
                                    context: context,
                                    widget: GeolocMapControlPanelAlert(
                                      date: widget.date,
                                      geolocStateList: widget.geolocStateList,
                                      templeInfoList: widget.templeInfoList,
                                      mapController: mapController,
                                      currentZoomEightTeen: currentZoomEightTeen,
                                      selectedHourMap: selectedHourMap,
                                      minMaxLatLngMap: <String, double>{
                                        'minLat': minLat,
                                        'maxLng': maxLng,
                                        'maxLat': maxLat,
                                        'minLng': minLng,
                                      },
                                      displayTempMap: widget.displayTempMap,
                                    ),
                                    paddingTop: context.screenSize.height * 0.65,
                                    clearBarrierColor: true,
                                  );
                                },
                                icon: const Icon(Icons.info),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading) ...<Widget>[
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  ///
  void makeSelectedHourMap() {
    selectedHourMap = <String, List<String>>{};

    for (final GeolocModel element in widget.geolocStateList) {
      selectedHourMap[element.time.split(':')[0]] = <String>[];
    }

    for (final GeolocModel element in widget.geolocStateList) {
      selectedHourMap[element.time.split(':')[0]]?.add(element.time);
    }
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
  void setDefaultBoundsMap() {
    if (widget.geolocStateList.length > 1) {
      final int currentPaddingIndex =
          ref.watch(appParamProvider.select((AppParamsResponseState value) => value.currentPaddingIndex));

      final LatLngBounds bounds = LatLngBounds.fromPoints(<LatLng>[LatLng(minLat, maxLng), LatLng(maxLat, minLng)]);

      final CameraFit cameraFit = CameraFit.bounds(bounds: bounds, padding: EdgeInsets.all(currentPaddingIndex * 10));

      mapController.fitCamera(cameraFit);

      /// これは残しておく
      // final LatLng newCenter = mapController.camera.center;

      final double newZoom = mapController.camera.zoom;

      setState(() => currentZoom = newZoom);

      ref.read(appParamProvider.notifier).setCurrentZoom(zoom: newZoom);

      getBoundsZoomValue = true;
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
          // ignore: use_if_null_to_convert_nulls_to_bools
          child: (widget.displayMonthMap)
              ? const Icon(Icons.ac_unit, size: 20, color: Colors.redAccent)
              : CircleAvatar(
                  // ignore: use_if_null_to_convert_nulls_to_bools
                  backgroundColor: (selectedTimeGeoloc != null && selectedTimeGeoloc.time == element.time)
                      ? Colors.redAccent.withOpacity(0.5)

                      // ignore: use_if_null_to_convert_nulls_to_bools
                      : (widget.displayTempMap == true)
                          ? Colors.orangeAccent.withOpacity(0.5)
                          : Colors.green[900]?.withOpacity(0.5),
                  child: Text(element.time, style: const TextStyle(color: Colors.white, fontSize: 10)),
                ),
        ),
      );
    }
  }

  ///
  List<LatLng> calculateCirclePoints(LatLng center, double radiusMeters) {
    const int points = 64;

    const double earthRadius = 6378137.0;

    final double lat = center.latitude * pi / 180.0;

    final double lng = center.longitude * pi / 180.0;

    final double d = radiusMeters / earthRadius;

    final List<LatLng> circlePoints = <LatLng>[];

    for (int i = 0; i <= points; i++) {
      final double angle = 2 * pi * i / points;

      final double latOffset = asin(sin(lat) * cos(d) + cos(lat) * sin(d) * cos(angle));

      final double lngOffset = lng + atan2(sin(angle) * sin(d) * cos(lat), cos(d) - sin(lat) * sin(latOffset));

      circlePoints.add(LatLng(latOffset * 180.0 / pi, lngOffset * 180.0 / pi));
    }
    return circlePoints;
  }

  ///
  void makePolylineGeolocList({required GeolocModel geoloc}) {
    polylineGeolocList = <GeolocModel>[];

    final int pos = widget.geolocStateList.indexWhere((GeolocModel element) => element.time == geoloc.time);

    if (pos > 0) {
      polylineGeolocList.add(widget.geolocStateList[pos - 1]);
      polylineGeolocList.add(geoloc);
    }
  }
}
