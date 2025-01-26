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

  List<LatLng> latLngList = <LatLng>[];

  final List<LatLng> tappedPoints = <LatLng>[];

  List<LatLng> enclosedMarkers = <LatLng>[];

  Map<String, GeolocModel> latLngGeolocModelMap = <String, GeolocModel>{};

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
              onTap: (TapPosition tapPosition, LatLng latlng) => setState(() => tappedPoints.add(latlng)),
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

              if (tappedPoints.isNotEmpty)
                MarkerLayer(
                  markers: tappedPoints
                      .map(
                        (LatLng point) => Marker(
                          point: point,
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.circle, size: 20, color: Colors.purple),
                        ),
                      )
                      .toList(),
                ),

              if (tappedPoints.isNotEmpty)
                // ignore: always_specify_types
                PolygonLayer(
                  polygons: <Polygon<Object>>[
                    // ignore: always_specify_types
                    Polygon(
                      points: tappedPoints,
                      color: Colors.purple.withOpacity(0.1),
                      borderColor: Colors.purple,
                      borderStrokeWidth: 2,
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
                            if (!widget.displayMonthMap) ...<Widget>[
                              const SizedBox(width: 20),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                                child: IconButton(
                                  onPressed: () {
                                    ref.read(appParamProvider.notifier).setTimeGeolocDisplay(start: -1, end: 23);

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
                                      paddingTop: (widget.templeInfoList != null)
                                          ? context.screenSize.height * 0.55
                                          : context.screenSize.height * 0.6,
                                      clearBarrierColor: true,
                                    );
                                  },
                                  icon: const Icon(Icons.info),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (widget.walkRecord.step != 0 && widget.walkRecord.distance != 0) ...<Widget>[
                      Text(
                        'step: ${widget.walkRecord.step} / distance: ${widget.walkRecord.distance}',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                    if (widget.walkRecord.step == 0 || widget.walkRecord.distance == 0) ...<Widget>[
                      Container(),
                    ],
                    Text(
                      widget.geolocStateList.length.toString(),
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(),
                    Row(
                      children: <Widget>[
                        IconButton(
                            onPressed: () => _findEnclosedMarkers(), icon: const Icon(Icons.list, color: Colors.black)),
                        IconButton(
                            onPressed: () => _clearPolygon(), icon: const Icon(Icons.clear, color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (enclosedMarkers.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                ),
                height: context.screenSize.height * 0.3,
                child: displayInnerPolygonTime(),
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
    latLngList = <LatLng>[];

    for (final GeolocModel element in widget.geolocStateList) {
      latList.add(element.latitude.toDouble());
      lngList.add(element.longitude.toDouble());

      latLngList.add(LatLng(element.latitude.toDouble(), element.longitude.toDouble()));

      latLngGeolocModelMap['${element.latitude}|${element.longitude}'] = element;
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

  ///
  void _clearPolygon() {
    setState(() {
      tappedPoints.clear();
      enclosedMarkers.clear();
    });
  }

  ///
  void _findEnclosedMarkers() {
    if (tappedPoints.isEmpty) {
      return;
    }

    setState(() =>
        enclosedMarkers = latLngList.where((LatLng marker) => _isPointInsidePolygon(marker, tappedPoints)).toList());
  }

  /// ポイントがポリゴン内にあるかどうか
  /// 「射影法（Ray-Casting Algorithm）」
  bool _isPointInsidePolygon(LatLng point, List<LatLng> latLngList) {
    int intersectCount = 0;

    for (int i = 0; i < latLngList.length; i++) {
      /// 全体の処理概要
      /// ポリゴンの各辺を順番にチェックします。
      //
      /// ポリゴンは複数の点で構成されており、各点は頂点（vertex1, vertex2）として扱われます。
      /// 最後の頂点と最初の頂点をつなぐ処理も行うために (i + 1) % polygon.length を使用しています。
      ///
      /// 水平方向に射影（Ray）を投げ、交差点を数える:
      /// 指定した point から水平方向に仮想的な直線を引き、ポリゴンの各辺と交差する回数を数えます。
      /// 交差点の数が奇数ならば、その点はポリゴンの内部にあると判定します。

      final LatLng vertex1 = latLngList[i];
      final LatLng vertex2 = latLngList[(i + 1) % latLngList.length];

      /// 意図: point が現在の辺（vertex1 と vertex2 の間）と交差しうるかを判定します。
      /// 動作:
      /// vertex1 と vertex2 の緯度（latitude）の間に、point の緯度が含まれている場合に true となります。
      /// vertex1.latitude > point.latitude と vertex2.latitude > point.latitude が異なる値である場合に交差が発生します。

      final bool flag1 = ((vertex1.latitude > point.latitude) != (vertex2.latitude > point.latitude));

      /// dbl1 (vertex2.longitude - vertex1.longitude):
      /// 現在の辺の x方向の長さ（経度差） を計算します。
      ///
      /// dbl2 (point.latitude - vertex1.latitude):
      /// 点（point）と辺の始点（vertex1）の y方向の差（緯度差） を計算します。
      ///
      /// dbl3 (vertex2.latitude - vertex1.latitude):
      /// 辺の y方向の長さ（緯度差） を計算します。

      final double dbl1 = vertex2.longitude - vertex1.longitude;
      final double dbl2 = point.latitude - vertex1.latitude;
      final double dbl3 = vertex2.latitude - vertex1.latitude;

      /// 現在の辺が、point.latitude と同じ高さ（y座標）で交差する x座標 を計算します。
      /// この結果が point.longitude より大きい場合、point の右側に交差点があることを示します。

      final bool flag2 = point.longitude < (dbl1 * dbl2 / dbl3) + vertex1.longitude;

      if (flag1 && flag2) {
        intersectCount++;
      }
    }

    /// 意味:
    /// 交差点の数が奇数の場合、点はポリゴンの内部にあります。
    /// 偶数の場合、点はポリゴンの外部にあります。

    return intersectCount.isOdd;
  }

  ///
  Widget displayInnerPolygonTime() {
    final List<Widget> list = <Widget>[];

    final List<GeolocModel> list2 = <GeolocModel>[];

    for (final LatLng element in enclosedMarkers) {
      final GeolocModel? latLngGeolocModel = latLngGeolocModelMap['${element.latitude}|${element.longitude}'];

      if (latLngGeolocModel != null) {
        list2.add(latLngGeolocModel);
      }
    }

    list2
      ..sort((GeolocModel a, GeolocModel b) => a.time.compareTo(b.time))
      ..forEach((GeolocModel element) {
        list.add(Text(element.time));
      });

    return SingleChildScrollView(
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.black),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: list),
      ),
    );
  }
}
