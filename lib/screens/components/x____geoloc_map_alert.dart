// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
//
// import '../../controllers/app_params/app_params_notifier.dart';
// import '../../controllers/app_params/app_params_response_state.dart';
// import '../../extensions/extensions.dart';
// import '../../models/geoloc_model.dart';
// import '../../models/temple_latlng_model.dart';
// import '../../models/walk_record_model.dart';
// import '../../utilities/tile_provider.dart';
// import '../parts/geoloc_dialog.dart';
// import 'geoloc_map_control_panel_alert.dart';
//
// // ignore: must_be_immutable
// class GeolocMapAlert extends ConsumerStatefulWidget {
//   GeolocMapAlert({
//     super.key,
//     required this.geolocStateList,
//     this.displayTempMap,
//     required this.displayMonthMap,
//     required this.walkRecord,
//     this.templeInfoList,
//   });
//
//   final List<GeolocModel> geolocStateList;
//   final bool? displayTempMap;
//   final bool displayMonthMap;
//   final WalkRecordModel walkRecord;
//   List<TempleInfoModel>? templeInfoList;
//
//   @override
//   ConsumerState<GeolocMapAlert> createState() => _GeolocMapAlertState();
// }
//
// class _GeolocMapAlertState extends ConsumerState<GeolocMapAlert> {
//   List<double> latList = <double>[];
//   List<double> lngList = <double>[];
//
//   double minLat = 0.0;
//   double maxLat = 0.0;
//   double minLng = 0.0;
//   double maxLng = 0.0;
//
//   final MapController mapController = MapController();
//
//   bool isBottomSheetVisible = false;
//
//   List<Marker> markerList = <Marker>[];
//
//   late ScrollController scrollController;
//   final ItemScrollController itemScrollController = ItemScrollController();
//   final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
//
//   List<GeolocModel> polylineGeolocList = <GeolocModel>[];
//
//   Map<String, List<String>> selectedHourMap = <String, List<String>>{};
//
//   bool isMarkerShow = true;
//
//   GeolocModel? selectedTimeGeoloc;
//
//   String selectedHour = '';
//
//   double? currentZoom;
//
//   double currentZoomEightTeen = 18;
//
//   int currentPaddingIndex = 5;
//
//   final double circleRadiusMeters = 100.0;
//
//   LatLng currentCenter = const LatLng(35.718532, 139.586639);
//
//   bool isTempleCircleShow = false;
//
//   ///
//   @override
//   void initState() {
//     super.initState();
//
//     scrollController = ScrollController();
//   }
//
//   ///
//   @override
//   void dispose() {
//     scrollController.dispose();
//
//     super.dispose();
//   }
//
//   // ///
//   // void _scrollToTop() {
//   //   _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
//   // }
//
//   bool getBoundsZoomValue = false;
//
//   bool showFirstMap = false;
//
//   ///
//   @override
//   Widget build(BuildContext context) {
//     makeSelectedHourMap();
//
//     makeMinMaxLatLng();
//
//     makeMarker();
//
//     if (!getBoundsZoomValue) {
//       WidgetsBinding.instance.addPostFrameCallback((_) async => setDefaultBoundsMap());
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         children: <Widget>[
//           FlutterMap(
//             mapController: mapController,
//             options: MapOptions(
//               initialCenter:
//                   LatLng(widget.geolocStateList[0].latitude.toDouble(), widget.geolocStateList[0].longitude.toDouble()),
//               initialZoom: currentZoomEightTeen,
//               onPositionChanged: (MapCamera position, bool isMoving) {
//                 if (isMoving) {
//                   setState(() => currentZoom = position.zoom);
//                 }
//               },
//             ),
//             children: <Widget>[
//               TileLayer(
//                 urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 tileProvider: CachedTileProvider(),
//                 userAgentPackageName: 'com.example.app',
//               ),
//
//               if (isMarkerShow) ...<Widget>[MarkerLayer(markers: markerList)],
//
//               // ignore: always_specify_types
//               PolylineLayer(
//                 polylines: <Polyline<Object>>[
//                   // ignore: always_specify_types
//                   Polyline(
//                     points: polylineGeolocList
//                         .map((GeolocModel e) => LatLng(e.latitude.toDouble(), e.longitude.toDouble()))
//                         .toList(),
//                     color: Colors.redAccent,
//                     strokeWidth: 5,
//                   ),
//                 ],
//               ),
//
//               if (isTempleCircleShow)
//                 // ignore: always_specify_types
//                 PolygonLayer(
//                   polygons: <Polygon<Object>>[
//                     // ignore: always_specify_types
//                     Polygon(
//                       points: calculateCirclePoints(currentCenter, circleRadiusMeters),
//                       color: Colors.redAccent.withOpacity(0.1),
//                       borderStrokeWidth: 2.0,
//                       borderColor: Colors.redAccent.withOpacity(0.5),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//           Positioned(
//             top: 5,
//             right: 5,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     DefaultTextStyle(
//                       style: const TextStyle(color: Colors.black),
//                       child: Column(
//                         children: <Widget>[
//                           Row(
//                             children: <Widget>[
//                               const SizedBox(width: 70, child: Text('size: ')),
//                               Container(
//                                 width: 60,
//                                 alignment: Alignment.topRight,
//                                 child: Text(
//                                   (currentZoom != null) ? currentZoom!.toStringAsFixed(2) : '',
//                                   style: const TextStyle(fontSize: 20, color: Colors.black),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: <Widget>[
//                               const SizedBox(width: 70, child: Text('padding: ')),
//                               Container(
//                                 width: 60,
//                                 alignment: Alignment.topRight,
//                                 child: Text(
//                                   currentPaddingIndex.toString(),
//                                   style: const TextStyle(fontSize: 20, color: Colors.black),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Container(
//                       decoration:
//                           BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
//                       child: IconButton(
//                         onPressed: () {
//                           // showBottomSheet(context);
//                           //
//
//                           GeolocDialog(
//                             context: context,
//                             widget: GeolocMapControlPanelAlert(
//                               geolocStateList: widget.geolocStateList,
//                               displayTempMap: widget.displayTempMap,
//                               templeInfoList: widget.templeInfoList,
//                               mapController: mapController,
//                               currentZoom: currentZoom,
//                               currentZoomEightTeen: currentZoomEightTeen,
//                               minMaxLatLngMap: <String, double>{
//                                 'minLat': minLat,
//                                 'maxLng': maxLng,
//                                 'maxLat': maxLat,
//                                 'minLng': minLng,
//                               },
//                               currentPaddingIndex: currentPaddingIndex,
//                               selectedHourMap: selectedHourMap,
//                             ),
//                             paddingTop: context.screenSize.height * 0.65,
//                             clearBarrierColor: true,
//                           );
//                         },
//                         icon: const Icon(Icons.info),
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (!showFirstMap) ...<Widget>[
//                   const SizedBox(height: 10),
//                   IconButton(
//                     onPressed: () {
//                       setState(() {
//                         /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドアワー）
//                         selectedHour = '';
//
//                         /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドタイムジオロック）
//                         selectedTimeGeoloc = null;
//
//                         showFirstMap = true;
//                       });
//
//                       setDefaultBoundsMap();
//                     },
//                     icon: const Icon(Icons.map, color: Colors.black),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   ///
//   void makeMinMaxLatLng() {
//     for (final GeolocModel element in widget.geolocStateList) {
//       latList.add(element.latitude.toDouble());
//       lngList.add(element.longitude.toDouble());
//     }
//
//     if (latList.isNotEmpty && lngList.isNotEmpty) {
//       minLat = latList.reduce(min);
//       maxLat = latList.reduce(max);
//       minLng = lngList.reduce(min);
//       maxLng = lngList.reduce(max);
//     }
//   }
//
//   ///
//   void setDefaultBoundsMap() {
//     if (widget.geolocStateList.length > 1) {
//       final LatLngBounds bounds = LatLngBounds.fromPoints(<LatLng>[LatLng(minLat, maxLng), LatLng(maxLat, minLng)]);
//
//       final CameraFit cameraFit = CameraFit.bounds(bounds: bounds, padding: EdgeInsets.all(currentPaddingIndex * 10));
//
//       mapController.fitCamera(cameraFit);
//
//       /// これは残しておく
//       // final LatLng newCenter = mapController.camera.center;
//
//       final double newZoom = mapController.camera.zoom;
//
//       setState(() => currentZoom = newZoom);
//
//       getBoundsZoomValue = true;
//     }
//   }
//
//   ///
//   void showBottomSheet(BuildContext context) {
//     final List<String> timeList = <String>[];
//     for (final GeolocModel element in widget.geolocStateList) {
//       final List<String> exTime = element.time.split(':');
//       if (!timeList.contains(exTime[0])) {
//         timeList.add(exTime[0]);
//       }
//     }
//
//     // ignore: inference_failure_on_function_invocation
//     showModalBottomSheet(
//       context: context,
//       barrierColor: Colors.transparent,
//       backgroundColor: Colors.black.withOpacity(0.6),
//
//       builder: (BuildContext context) {
//         return Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               /////
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Row(
//                     children: <Widget>[
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             isMarkerShow = !isMarkerShow;
//
//                             polylineGeolocList = (!isMarkerShow) ? widget.geolocStateList : <GeolocModel>[];
//
//                             /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドアワー）
//                             selectedHour = '';
//
//                             /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドタイムジオロック）
//                             selectedTimeGeoloc = null;
//                           });
//                         },
//                         child: const Icon(Icons.stacked_line_chart),
//                       ),
//                       const SizedBox(width: 20),
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドアワー）
//                             selectedHour = '';
//
//                             /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドタイムジオロック）
//                             selectedTimeGeoloc = null;
//                           });
//
//                           setDefaultBoundsMap();
//                         },
//                         child: const Icon(Icons.center_focus_strong),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: <Widget>[
//                       GestureDetector(
//                         onTap: () {
//                           ///
//
//                           if (widget.geolocStateList.length == 1 || selectedTimeGeoloc != null) {
//                             if (currentZoom != null) {
//                               setState(() => currentZoom = currentZoom! + 1);
//
//                               mapController.move(
//                                 (selectedTimeGeoloc == null || currentZoom == null)
//                                     ? LatLng(
//                                         widget.geolocStateList[0].latitude.toDouble(),
//                                         widget.geolocStateList[0].longitude.toDouble(),
//                                       )
//                                     : LatLng(
//                                         selectedTimeGeoloc!.latitude.toDouble(),
//                                         selectedTimeGeoloc!.longitude.toDouble(),
//                                       ),
//                                 currentZoom!,
//                               );
//                             }
//                           } else {
//                             setState(() {
//                               currentPaddingIndex = currentPaddingIndex + 5;
//                             });
//
//                             setDefaultBoundsMap();
//                           }
//
//                           ///
//                         },
//                         child: const Icon(Icons.add),
//                       ),
//                       const SizedBox(width: 20),
//                       GestureDetector(
//                         onTap: () {
//                           ///
//
//                           if (widget.geolocStateList.length == 1 || selectedTimeGeoloc != null) {
//                             if (currentZoom != null) {
//                               setState(() => currentZoom = currentZoom! - 1);
//
//                               mapController.move(
//                                 (selectedTimeGeoloc == null || currentZoom == null)
//                                     ? LatLng(
//                                         widget.geolocStateList[0].latitude.toDouble(),
//                                         widget.geolocStateList[0].longitude.toDouble(),
//                                       )
//                                     : LatLng(
//                                         selectedTimeGeoloc!.latitude.toDouble(),
//                                         selectedTimeGeoloc!.longitude.toDouble(),
//                                       ),
//                                 currentZoom!,
//                               );
//                             }
//                           } else {
//                             setState(() {
//                               currentPaddingIndex = currentPaddingIndex - 5;
//                               if (currentPaddingIndex < 5) {
//                                 currentPaddingIndex = 5;
//                               }
//                             });
//
//                             setDefaultBoundsMap();
//                           }
//
//                           ///
//                         },
//                         child: const Icon(Icons.remove),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//
//               /////
//
//               const SizedBox(height: 20),
//
//               /////
//
//               SingleChildScrollView(
//                 controller: scrollController,
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: timeList.map((String e) {
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 10),
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドアワー）
//                             selectedHour = e;
//
//                             /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドタイムジオロック）
//                             selectedTimeGeoloc = widget.geolocStateList
//                                 .firstWhere((GeolocModel e2) => e2.time == selectedHourMap[e]?[0]);
//                           });
//
//                           /// ここでappParamProviderの変数を変更（セレクテッドアワー）
//                           ref.read(appParamProvider.notifier).setSelectedHour(hour: e);
//
//                           /// ここでappParamProviderの変数を変更（セレクテッドタイムジオロック）
//                           ref.read(appParamProvider.notifier).setSelectedTimeGeoloc(
//                               geoloc: widget.geolocStateList
//                                   .firstWhere((GeolocModel e2) => e2.time == selectedHourMap[e]?[0]));
//
//                           itemScrollController.jumpTo(
//                             index: widget.geolocStateList
//                                 .indexWhere((GeolocModel element) => element.time.split(':')[0] == e),
//                           );
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
//                           decoration: BoxDecoration(color: Colors.white.withOpacity(0.3)),
//                           child: Text(e, style: const TextStyle(fontSize: 12)),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//
//               /////
//
//               SizedBox(
//                 height: 60,
//                 child: ScrollablePositionedList.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: widget.geolocStateList.length,
//                   itemScrollController: itemScrollController,
//                   itemPositionsListener: itemPositionsListener,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 5),
//                       child: GestureDetector(
//                         onTap: () {
//                           ref.read(appParamProvider.notifier).setIsMarkerShow(flag: false);
//
//                           setState(() {
//                             /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドアワー）
//                             selectedHour = widget.geolocStateList[index].time.split(':')[0];
//
//                             /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドタイムジオロック）
//                             selectedTimeGeoloc = widget.geolocStateList[index];
//                           });
//
//                           /// ここでappParamProviderの変数を変更（セレクテッドアワー）
//                           ref
//                               .read(appParamProvider.notifier)
//                               .setSelectedHour(hour: widget.geolocStateList[index].time.split(':')[0]);
//
//                           /// ここでappParamProviderの変数を変更（セレクテッドタイムジオロック）
//                           ref
//                               .read(appParamProvider.notifier)
//                               .setSelectedTimeGeoloc(geoloc: widget.geolocStateList[index]);
//
//                           mapController.move(
//                             LatLng(
//                               widget.geolocStateList[index].latitude.toDouble(),
//                               widget.geolocStateList[index].longitude.toDouble(),
//                             ),
//                             currentZoom ?? currentZoomEightTeen,
//                           );
//
//                           makePolylineGeolocList(geoloc: widget.geolocStateList[index]);
//                         },
//                         child: CircleAvatar(
//                           // ignore: use_if_null_to_convert_nulls_to_bools
//                           backgroundColor: (widget.displayTempMap == true)
//                               ? Colors.orangeAccent.withOpacity(0.5)
//                               : Colors.green[900]?.withOpacity(0.5),
//                           child: Text(
//                             widget.geolocStateList[index].time,
//                             style: const TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//               /////
//
//               if (widget.templeInfoList != null) ...<Widget>[
//                 SingleChildScrollView(
//                   controller: scrollController,
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: widget.templeInfoList!.map((TempleInfoModel element) {
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドタイムジオロック）
//                             selectedTimeGeoloc = GeolocModel(
//                               id: 0,
//                               year: widget.geolocStateList[0].year,
//                               month: widget.geolocStateList[0].month,
//                               day: widget.geolocStateList[0].day,
//                               time: '',
//                               latitude: element.latitude,
//                               longitude: element.longitude,
//                             );
//
//                             currentZoom = 17;
//
//                             isTempleCircleShow = true;
//
//                             currentCenter = LatLng(element.latitude.toDouble(), element.longitude.toDouble());
//                           });
//
//                           mapController.move(
//                             LatLng(element.latitude.toDouble(), element.longitude.toDouble()),
//                             currentZoom ?? currentZoomEightTeen,
//                           );
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.all(5),
//                           padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
//                           decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.3)),
//                           child: Text(element.temple, style: const TextStyle(fontSize: 12)),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//
//               /////
//             ],
//           ),
//         );
//       },
//       // ignore: always_specify_types
//     ).then((value) => setState(() => isBottomSheetVisible = false));
//
//     setState(() => isBottomSheetVisible = true);
//   }
//
//   ///
//   void makeSelectedHourMap() {
//     selectedHourMap = <String, List<String>>{};
//
//     for (final GeolocModel element in widget.geolocStateList) {
//       selectedHourMap[element.time.split(':')[0]] = <String>[];
//     }
//
//     for (final GeolocModel element in widget.geolocStateList) {
//       selectedHourMap[element.time.split(':')[0]]?.add(element.time);
//     }
//   }
//
//   ///
//   void makeMarker() {
//     markerList = <Marker>[];
//
//     final GeolocModel? selectedTimeGeoloc =
//         ref.watch(appParamProvider.select((AppParamsResponseState value) => value.selectedTimeGeoloc));
//
//     final String selectedHour =
//         ref.watch(appParamProvider.select((AppParamsResponseState value) => value.selectedHour));
//
//     for (final GeolocModel element in widget.geolocStateList) {
//       markerList.add(
//         Marker(
//           point: LatLng(element.latitude.toDouble(), element.longitude.toDouble()),
//           width: 40,
//           height: 40,
//           // ignore: use_if_null_to_convert_nulls_to_bools
//           child: (widget.displayMonthMap)
//               ? const Icon(Icons.ac_unit, size: 20, color: Colors.redAccent)
//               : CircleAvatar(
//                   // ignore: use_if_null_to_convert_nulls_to_bools
//                   backgroundColor: (selectedTimeGeoloc != null && selectedTimeGeoloc.time == element.time)
//                       ? Colors.redAccent.withOpacity(0.5)
//                       // ignore: use_if_null_to_convert_nulls_to_bools
//                       : (element.time.split(':')[0] == selectedHour)
//                           ? Colors.lime
//                           // ignore: use_if_null_to_convert_nulls_to_bools
//                           : (widget.displayTempMap == true)
//                               ? Colors.orangeAccent.withOpacity(0.5)
//                               : Colors.green[900]?.withOpacity(0.5),
//                   child: Text(element.time, style: const TextStyle(color: Colors.white, fontSize: 10)),
//                 ),
//         ),
//       );
//     }
//   }
//
//   ///
//   void makePolylineGeolocList({required GeolocModel geoloc}) {
//     polylineGeolocList = <GeolocModel>[];
//
//     final int pos = widget.geolocStateList.indexWhere((GeolocModel element) => element.time == geoloc.time);
//
//     if (pos > 0) {
//       polylineGeolocList.add(widget.geolocStateList[pos - 1]);
//       polylineGeolocList.add(geoloc);
//     }
//   }
//
//   ///
//   List<LatLng> calculateCirclePoints(LatLng center, double radiusMeters) {
//     const int points = 64;
//
//     const double earthRadius = 6378137.0;
//
//     final double lat = center.latitude * pi / 180.0;
//
//     final double lng = center.longitude * pi / 180.0;
//
//     final double d = radiusMeters / earthRadius;
//
//     final List<LatLng> circlePoints = <LatLng>[];
//
//     for (int i = 0; i <= points; i++) {
//       final double angle = 2 * pi * i / points;
//
//       final double latOffset = asin(sin(lat) * cos(d) + cos(lat) * sin(d) * cos(angle));
//
//       final double lngOffset = lng + atan2(sin(angle) * sin(d) * cos(lat), cos(d) - sin(lat) * sin(latOffset));
//
//       circlePoints.add(LatLng(latOffset * 180.0 / pi, lngOffset * 180.0 / pi));
//     }
//     return circlePoints;
//   }
// }
