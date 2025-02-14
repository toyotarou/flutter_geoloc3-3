import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

// import '../../controllers/app_params/app_params_notifier.dart';
// import '../../controllers/app_params/app_params_response_state.dart';
// import '../../controllers/geoloc/geoloc.dart';
// import '../../controllers/temple_photo/temple_photo_notifier.dart';
// import '../../controllers/temple_photo/temple_photo_response_state.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../models/temple_latlng_model.dart';
import '../../models/temple_photo_model.dart';
import '../../models/walk_record_model.dart';
import '../../utilities/tile_provider.dart';
import '../parts/button_error_overlay.dart';
import '../parts/error_dialog.dart';
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

class _GeolocMapAlertState extends ConsumerState<GeolocMapAlert> with ControllersMixin<GeolocMapAlert> {
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

  Map<String, List<TemplePhotoModel>> templePhotoDateMap = <String, List<TemplePhotoModel>>{};

  List<GeolocModel> gStateList = <GeolocModel>[];

  Set<LatLng> emphasisMarkers = <LatLng>{};

  Map<LatLng, int> emphasisMarkersIndices = <LatLng, int>{};

  List<GeolocModel> emphasisMarkersPositions = <GeolocModel>[];

  List<GlobalKey> globalKeyList = <GlobalKey>[];

  ///
  @override
  void initState() {
    super.initState();

    if (widget.displayMonthMap) {
      geolocNotifier.getAllGeoloc();
    }

    scrollController = ScrollController();

    // ignore: always_specify_types
    globalKeyList = List.generate(1000, (int index) => GlobalKey());

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

  ///
  @override
  Widget build(BuildContext context) {
    gStateList = <GeolocModel>[...widget.geolocStateList];

    makeSelectedHourMap();

    makeMinMaxLatLng();

    makeMarker();

    polylineGeolocList = (!appParamState.isMarkerShow) ? gStateList : <GeolocModel>[];

    if (appParamState.polylineGeolocModel != null) {
      makePolylineGeolocList(geoloc: appParamState.polylineGeolocModel!);
    }

    if (templePhotoState.templePhotoDateMap.value != null) {
      templePhotoDateMap = templePhotoState.templePhotoDateMap.value!;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(gStateList[0].latitude.toDouble(), gStateList[0].longitude.toDouble()),
              initialZoom: currentZoomEightTeen,
              onPositionChanged: (MapCamera position, bool isMoving) {
                if (isMoving) {
                  appParamNotifier.setCurrentZoom(zoom: position.zoom);
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
                                    appParamNotifier.setTimeGeolocDisplay(start: -1, end: 23);

                                    GeolocDialog(
                                      context: context,
                                      widget: GeolocMapControlPanelAlert(
                                        date: widget.date,
                                        geolocStateList: gStateList,
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
                                        templePhotoDateList:
                                            templePhotoDateMap[widget.date.yyyymmdd] ?? <TemplePhotoModel>[],
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
                      gStateList.length.toString(),
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              onPressed: () => _findEnclosedMarkers(),
                              icon: const Icon(Icons.list, color: Colors.purple)),
                          IconButton(
                              onPressed: () => _clearPolygon(), icon: const Icon(Icons.clear, color: Colors.purple)),
                        ],
                      ),
                    ),
                    if (widget.displayMonthMap) ...<Widget>[Container()],
                    if (!widget.displayMonthMap) ...<Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                                onPressed: () => restrictionAreaMarkerEmphasis(),
                                icon: const Icon(Icons.check_box, color: Colors.red)),
                            IconButton(
                                onPressed: () => displayEmphasisMarkersList(),
                                icon: const Icon(Icons.list, color: Colors.red)),
                            IconButton(
                              onPressed: () => setState(() {
                                emphasisMarkers.clear();

                                emphasisMarkersIndices.clear();
                              }),
                              icon: const Icon(Icons.clear, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
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
          if (widget.displayMonthMap) ...<Widget>[
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: context.screenSize.width,
                child: Row(
                  children: <Widget>[
                    Row(
                      // ignore: always_specify_types
                      children: List.generate(2, (int index) => index).map((int e) {
                        final String blockYm = DateTime(
                          widget.date.yyyymmdd.split('-')[0].toInt(),
                          widget.date.yyyymmdd.split('-')[1].toInt() - (e + 1),
                        ).yyyymm;

                        return GestureDetector(
                          onTap: () {
                            if (e == 0) {
                              if (appParamState.monthGeolocAddMonthButtonLabelList.length == 2) {
                                showButtonErrorOverlay(
                                  context: context,
                                  buttonKey: globalKeyList[e],
                                  message: '途中月の消去はできません。',
                                  displayDuration: const Duration(seconds: 2),
                                );

                                return;
                              }
                            }

                            if (e == 1) {
                              if (appParamState.monthGeolocAddMonthButtonLabelList.isEmpty) {
                                showButtonErrorOverlay(
                                  context: context,
                                  buttonKey: globalKeyList[e],
                                  message: '飛び月の追加はできません。',
                                  displayDuration: const Duration(seconds: 2),
                                );

                                return;
                              }
                            }

                            appParamNotifier.setMonthGeolocAddMonthButtonLabelList(str: blockYm);
                          },
                          child: Container(
                            key: globalKeyList[e],
                            width: 60,
                            height: 60,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: (appParamState.monthGeolocAddMonthButtonLabelList.contains(blockYm))
                                  ? Colors.redAccent.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(height: 10),
                                Text('-${e + 1}month', style: const TextStyle(fontSize: 10)),
                                const SizedBox(height: 5),
                                Text(blockYm),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 150),
                    Container(
                      decoration:
                          BoxDecoration(color: Colors.blue.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        onPressed: () => setDefaultBoundsMap(),
                        icon: const Icon(FontAwesomeIcons.expand),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (isLoading) ...<Widget>[const Center(child: CircularProgressIndicator())],
        ],
      ),
    );
  }

  ///
  void restrictionAreaMarkerEmphasis() {
    final LatLngBounds bounds = mapController.camera.visibleBounds;

    final Set<LatLng> set = <LatLng>{};

    for (final GeolocModel pos in gStateList) {
      if (bounds.contains(LatLng(pos.latitude.toDouble(), pos.longitude.toDouble()))) {
        set.add(LatLng(pos.latitude.toDouble(), pos.longitude.toDouble()));
      }
    }

    if (set.length > 20) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () => error_dialog(
            // ignore: use_build_context_synchronously
            context: context,
            title: '処理続行不可',
            content: 'ピックアップされたマーカーが多すぎます。'),
      );

      return;
    }

    final List<LatLng> list = <LatLng>[...set];

    final Map<String, LatLng> map = <String, LatLng>{};

    final List<String> list2 = <String>[];

    final Map<LatLng, int> map2 = <LatLng, int>{};

    for (final LatLng element in list) {
      for (final GeolocModel element2 in gStateList) {
        if (element.latitude == element2.latitude.toDouble() && element.longitude == element2.longitude.toDouble()) {
          list2.add('${element2.year}-${element2.month}-${element2.day} ${element2.time}');

          map['${element2.year}-${element2.month}-${element2.day} ${element2.time}'] = element;
        }
      }
    }

    int i = 0;

    list2
      ..sort((String a, String b) => a.compareTo(b))
      ..forEach((String element) {
        if (map[element] != null) {
          map2[map[element]!] = i + 1;

          i++;
        }
      });

    setState(() {
      emphasisMarkers = set;

      emphasisMarkersIndices = map2;
    });
  }

  ///
  void displayEmphasisMarkersList() {
    final LatLngBounds bounds = mapController.camera.visibleBounds;

    emphasisMarkersPositions = gStateList
        .where((GeolocModel geolocModel) =>
            bounds.contains(LatLng(geolocModel.latitude.toDouble(), geolocModel.longitude.toDouble())))
        .toList();

    // ignore: inference_failure_on_function_invocation
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('可視範囲のマーカー座標'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: emphasisMarkersPositions.map((GeolocModel geolocModel) => Text(geolocModel.time)).toList(),
          ),
        ),
        actions: <Widget>[TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('閉じる'))],
      ),
    );
  }

  ///
  void makeSelectedHourMap() {
    selectedHourMap = <String, List<String>>{};

    for (final GeolocModel element in gStateList) {
      selectedHourMap[element.time.split(':')[0]] = <String>[];
    }

    for (final GeolocModel element in gStateList) {
      selectedHourMap[element.time.split(':')[0]]?.add(element.time);
    }
  }

  ///
  void makeMinMaxLatLng() {
    latList = <double>[];

    lngList = <double>[];

    latLngList = <LatLng>[];

    if (appParamState.monthGeolocAddMonthButtonLabelList.isNotEmpty) {
      for (final String element in appParamState.monthGeolocAddMonthButtonLabelList) {
        for (final GeolocModel element2 in geolocState.allGeolocList) {
          if ('${element2.year}-${element2.month}' == element) {
            gStateList.add(element2);
          }
        }
      }
    }

    for (final GeolocModel element in gStateList) {
      latList.add(element.latitude.toDouble());
      lngList.add(element.longitude.toDouble());

      final LatLng latlng = LatLng(element.latitude.toDouble(), element.longitude.toDouble());

      latLngList.add(latlng);

      latLngGeolocModelMap['${latlng.latitude}|${latlng.longitude}'] = element;
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
    if (gStateList.length > 1) {
      final LatLngBounds bounds = LatLngBounds.fromPoints(<LatLng>[LatLng(minLat, maxLng), LatLng(maxLat, minLng)]);

      final CameraFit cameraFit =
          CameraFit.bounds(bounds: bounds, padding: EdgeInsets.all(appParamState.currentPaddingIndex * 10));

      mapController.fitCamera(cameraFit);

      /// これは残しておく
      // final LatLng newCenter = mapController.camera.center;

      final double newZoom = mapController.camera.zoom;

      setState(() => currentZoom = newZoom);

      appParamNotifier.setCurrentZoom(zoom: newZoom);
    }
  }

  ///
  void makeMarker() {
    markerList = <Marker>[];

    for (final GeolocModel element in gStateList) {
      final bool isRed = emphasisMarkers.contains(LatLng(element.latitude.toDouble(), element.longitude.toDouble()));

      final int? badgeIndex = emphasisMarkersIndices[LatLng(element.latitude.toDouble(), element.longitude.toDouble())];

      markerList.add(
        Marker(
          point: LatLng(element.latitude.toDouble(), element.longitude.toDouble()),
          width: 40,
          height: 40,
          // ignore: use_if_null_to_convert_nulls_to_bools
          child: (widget.displayMonthMap)
              ? const Icon(Icons.ac_unit, size: 20, color: Colors.redAccent)
              : Stack(
                  children: <Widget>[
                    CircleAvatar(
                      // ignore: use_if_null_to_convert_nulls_to_bools
                      backgroundColor: isRed
                          ? Colors.redAccent.withOpacity(0.5)
                          : (appParamState.selectedTimeGeoloc != null &&
                                  appParamState.selectedTimeGeoloc!.time == element.time)
                              ? Colors.redAccent.withOpacity(0.5)

                              // ignore: use_if_null_to_convert_nulls_to_bools
                              : (widget.displayTempMap == true)
                                  ? Colors.orangeAccent.withOpacity(0.5)
                                  : Colors.green[900]?.withOpacity(0.5),
                      child: Text(element.time, style: const TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                    if (badgeIndex != null)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Text(
                            badgeIndex.toString(),
                            style: const TextStyle(fontSize: 10, color: Colors.black),
                          ),
                        ),
                      ),
                  ],
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

    final int pos = gStateList.indexWhere((GeolocModel element) => element.time == geoloc.time);

    if (pos > 0) {
      polylineGeolocList.add(gStateList[pos - 1]);
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

    final Map<String, GeolocModel> map = <String, GeolocModel>{};
    final List<String> list2 = <String>[];

    for (final LatLng element in enclosedMarkers) {
      final GeolocModel? latLngGeolocModel = latLngGeolocModelMap['${element.latitude}|${element.longitude}'];

      if (latLngGeolocModel != null) {
        final String key =
            '${latLngGeolocModel.year}-${latLngGeolocModel.month}-${latLngGeolocModel.day} ${latLngGeolocModel.time}';

        map[key] = latLngGeolocModel;

        list2.add(key);
      }
    }

    int i = 0;

    list2.toSet().toList()
      ..sort((String a, String b) => a.compareTo(b))
      ..forEach((String element) {
        if (map[element] != null) {
          list.add(Text('${(i + 1).toString().padLeft(3, '0')}. $element'));

          i++;
        }
      });

    return SingleChildScrollView(
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.black),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: list),
      ),
    );
  }
}
