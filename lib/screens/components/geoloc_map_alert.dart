import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../controllers/app_params/app_params_notifier.dart';
import '../../controllers/app_params/app_params_response_state.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../models/temple_latlng_model.dart';
import '../../models/walk_record_model.dart';
import '../../utilities/tile_provider.dart';

class GeolocMapAlert extends ConsumerStatefulWidget {
  const GeolocMapAlert(
      {super.key,
      required this.geolocStateList,
      this.displayTempMap,
      required this.displayMonthMap,
      required this.walkRecord,
      this.templeInfoList});

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

  //
  // bool isBottomSheetVisible = false;
  //
  List<Marker> markerList = <Marker>[];

  //
  late ScrollController scrollController;

  // final ItemScrollController itemScrollController = ItemScrollController();
  // final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  //
  List<GeolocModel> polylineGeolocList = <GeolocModel>[];

  //
  Map<String, List<String>> selectedHourMap = <String, List<String>>{};

  //
  // bool isMarkerShow = true;
  //
  // GeolocModel? selectedTimeGeoloc;
  //
  // String selectedHour = '';
  //
  double? currentZoom;

  //
  double currentZoomEightTeen = 18;

  //
  // int currentPaddingIndex = 5;
  //
  // final double circleRadiusMeters = 100.0;
  //
  // LatLng currentCenter = const LatLng(35.718532, 139.586639);
  //
  // bool isTempleCircleShow = false;

  ///
  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
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

  bool showFirstMap = false;

  ///
  @override
  Widget build(BuildContext context) {
    makeSelectedHourMap();

    makeMinMaxLatLng();

    makeMarker();

    if (!getBoundsZoomValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) async => setDefaultBoundsMap());
    }

    final bool isMarkerShow = ref.watch(appParamProvider.select((AppParamsResponseState value) => value.isMarkerShow));

    final int currentPaddingIndex =
        ref.watch(appParamProvider.select((AppParamsResponseState value) => value.currentPaddingIndex));

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
                  // setState(() => currentZoom = position.zoom);
                  //
                  //
                  //
                  //

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

              if (isMarkerShow) ...<Widget>[MarkerLayer(markers: markerList)],

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

              // if (isTempleCircleShow)
              //   // ignore: always_specify_types
              //   PolygonLayer(
              //     polygons: <Polygon<Object>>[
              //       // ignore: always_specify_types
              //       Polygon(
              //         points: calculateCirclePoints(currentCenter, circleRadiusMeters),
              //         color: Colors.redAccent.withOpacity(0.1),
              //         borderStrokeWidth: 2.0,
              //         borderColor: Colors.redAccent.withOpacity(0.5),
              //       ),
              //     ],
              //   ),
              //
              //
              //
              //
              //
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    DefaultTextStyle(
                      style: const TextStyle(color: Colors.black),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const SizedBox(width: 70, child: Text('size: ')),
                              Container(
                                width: 60,
                                alignment: Alignment.topRight,
                                // child: Text(
                                //   (currentZoom != null) ? currentZoom!.toStringAsFixed(2) : '',
                                //   style: const TextStyle(fontSize: 20, color: Colors.black),
                                // ),
                                //
                                //
                                //
                                //
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              const SizedBox(width: 70, child: Text('padding: ')),
                              Container(
                                width: 60,
                                alignment: Alignment.topRight,
                                child: Text(
                                  currentPaddingIndex.toString(),
                                  style: const TextStyle(fontSize: 20, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        onPressed: () {
                          // showBottomSheet(context);
                          //

                          // GeolocDialog(
                          //   context: context,
                          //   widget: GeolocMapControlPanelAlert(
                          //     geolocStateList: widget.geolocStateList,
                          //     displayTempMap: widget.displayTempMap,
                          //     templeInfoList: widget.templeInfoList,
                          //     mapController: mapController,
                          //     currentZoom: currentZoom,
                          //     currentZoomEightTeen: currentZoomEightTeen,
                          //     minMaxLatLngMap: <String, double>{
                          //       'minLat': minLat,
                          //       'maxLng': maxLng,
                          //       'maxLat': maxLat,
                          //       'minLng': minLng,
                          //     },
                          //     currentPaddingIndex: currentPaddingIndex,
                          //     selectedHourMap: selectedHourMap,
                          //   ),
                          //   paddingTop: context.screenSize.height * 0.65,
                          //   clearBarrierColor: true,
                          // );
                          //
                          //
                          //
                          //
                          //
                        },
                        icon: const Icon(Icons.info),
                      ),
                    ),
                  ],
                ),
                if (!showFirstMap) ...<Widget>[
                  const SizedBox(height: 10),
                  IconButton(
                    onPressed: () {
                      setState(() => showFirstMap = true);

                      setDefaultBoundsMap();
                    },
                    icon: const Icon(Icons.map, color: Colors.black),
                  ),
                ],
              ],
            ),
          ),
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

    final String selectedHour =
        ref.watch(appParamProvider.select((AppParamsResponseState value) => value.selectedHour));

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
                      : (element.time.split(':')[0] == selectedHour)
                          ? Colors.lime
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
}
