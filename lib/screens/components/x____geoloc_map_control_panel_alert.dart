// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
//
// import '../../controllers/app_params/app_params_notifier.dart';
// import '../../extensions/extensions.dart';
// import '../../models/geoloc_model.dart';
// import '../../models/temple_latlng_model.dart';
//
// class GeolocMapControlPanelAlert extends ConsumerStatefulWidget {
//   const GeolocMapControlPanelAlert({
//     super.key,
//     required this.geolocStateList,
//     this.displayTempMap,
//     this.templeInfoList,
//     required this.mapController,
//     this.currentZoom,
//     required this.currentZoomEightTeen,
//     required this.minMaxLatLngMap,
//     required this.currentPaddingIndex,
//     required this.selectedHourMap,
//   });
//
//   final List<GeolocModel> geolocStateList;
//   final bool? displayTempMap;
//   final List<TempleInfoModel>? templeInfoList;
//   final MapController mapController;
//   final double? currentZoom;
//   final double currentZoomEightTeen;
//   final Map<String, double> minMaxLatLngMap;
//   final int currentPaddingIndex;
//   final Map<String, List<String>> selectedHourMap;
//
//   ///
//   @override
//   ConsumerState<GeolocMapControlPanelAlert> createState() => _GeolocMapControlPanelAlertState();
// }
//
// class _GeolocMapControlPanelAlertState extends ConsumerState<GeolocMapControlPanelAlert> {
//   late ScrollController scrollController;
//   final ItemScrollController itemScrollController = ItemScrollController();
//   final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
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
//   ///
//   @override
//   Widget build(BuildContext context) {
//     final List<String> timeList = <String>[];
//     for (final GeolocModel element in widget.geolocStateList) {
//       final List<String> exTime = element.time.split(':');
//       if (!timeList.contains(exTime[0])) {
//         timeList.add(exTime[0]);
//       }
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           child: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 /////
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Row(
//                       children: <Widget>[
//                         GestureDetector(
//                           onTap: () {
//                             // setState(() {
//                             //   isMarkerShow = !isMarkerShow;
//                             //
//                             //   polylineGeolocList = (!isMarkerShow) ? widget.geolocStateList : <GeolocModel>[];
//                             //
//                             //   /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドアワー）
//                             //   selectedHour = '';
//                             //
//                             //   /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドタイムジオロック）
//                             //   selectedTimeGeoloc = null;
//                             // });
//                             //
//                             //
//                             //
//                           },
//                           child: const Icon(Icons.stacked_line_chart),
//                         ),
//                         const SizedBox(width: 20),
//                         GestureDetector(
//                           onTap: () {
//                             // setState(() {
//                             //   /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドアワー）
//                             //   selectedHour = '';
//                             //
//                             //   /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドタイムジオロック）
//                             //   selectedTimeGeoloc = null;
//                             // });
//                             //
//                             //
//                             //
//                             //
//                             //
//                             //
//                             // setDefaultBoundsMap();
//                             //
//                             //
//                           },
//                           child: const Icon(Icons.center_focus_strong),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: <Widget>[
//                         GestureDetector(
//                           onTap: () {
//                             ///
//
//                             // if (widget.geolocStateList.length == 1 || selectedTimeGeoloc != null) {
//                             //   if (currentZoom != null) {
//                             //     setState(() => currentZoom = currentZoom! + 1);
//                             //
//                             //     mapController.move(
//                             //       (selectedTimeGeoloc == null || currentZoom == null)
//                             //           ? LatLng(
//                             //         widget.geolocStateList[0].latitude.toDouble(),
//                             //         widget.geolocStateList[0].longitude.toDouble(),
//                             //       )
//                             //           : LatLng(
//                             //         selectedTimeGeoloc!.latitude.toDouble(),
//                             //         selectedTimeGeoloc!.longitude.toDouble(),
//                             //       ),
//                             //       currentZoom!,
//                             //     );
//                             //   }
//                             // } else {
//                             //   setState(() {
//                             //     currentPaddingIndex = currentPaddingIndex + 5;
//                             //   });
//                             //
//                             //   setDefaultBoundsMap();
//                             // }
//                             //
//                             //
//                             //
//
//                             ///
//                           },
//                           child: const Icon(Icons.add),
//                         ),
//                         const SizedBox(width: 20),
//                         GestureDetector(
//                           onTap: () {
//                             ///
//
//                             // if (widget.geolocStateList.length == 1 || selectedTimeGeoloc != null) {
//                             //   if (currentZoom != null) {
//                             //     setState(() => currentZoom = currentZoom! - 1);
//                             //
//                             //     mapController.move(
//                             //       (selectedTimeGeoloc == null || currentZoom == null)
//                             //           ? LatLng(
//                             //         widget.geolocStateList[0].latitude.toDouble(),
//                             //         widget.geolocStateList[0].longitude.toDouble(),
//                             //       )
//                             //           : LatLng(
//                             //         selectedTimeGeoloc!.latitude.toDouble(),
//                             //         selectedTimeGeoloc!.longitude.toDouble(),
//                             //       ),
//                             //       currentZoom!,
//                             //     );
//                             //   }
//                             // } else {
//                             //   setState(() {
//                             //     currentPaddingIndex = currentPaddingIndex - 5;
//                             //     if (currentPaddingIndex < 5) {
//                             //       currentPaddingIndex = 5;
//                             //     }
//                             //   });
//                             //
//                             //   setDefaultBoundsMap();
//                             // }
//                             //
//                             //
//                             //
//
//                             ///
//                           },
//                           child: const Icon(Icons.remove),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//
//                 /////
//
//                 const SizedBox(height: 20),
//
//                 /////
//
//                 SingleChildScrollView(
//                   controller: scrollController,
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: timeList.map((String e) {
//                       return Padding(
//                         padding: const EdgeInsets.only(right: 10),
//                         child: GestureDetector(
//                           onTap: () {
//                             // setState(() {
//                             //   /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドアワー）
//                             //   selectedHour = e;
//                             //
//                             //   /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドタイムジオロック）
//                             //   selectedTimeGeoloc = widget.geolocStateList
//                             //       .firstWhere((GeolocModel e2) => e2.time == selectedHourMap[e]?[0]);
//                             // });
//                             //
//                             //
//                             //
//                             //
//
//                             /// ここでappParamProviderの変数を変更（セレクテッドアワー）
//                             ref.read(appParamProvider.notifier).setSelectedHour(hour: e);
//
//                             /// ここでappParamProviderの変数を変更（セレクテッドタイムジオロック）
//                             ref.read(appParamProvider.notifier).setSelectedTimeGeoloc(
//                                 geoloc: widget.geolocStateList
//                                     .firstWhere((GeolocModel e2) => e2.time == widget.selectedHourMap[e]?[0]));
//
//                             itemScrollController.jumpTo(
//                               index: widget.geolocStateList
//                                   .indexWhere((GeolocModel element) => element.time.split(':')[0] == e),
//                             );
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
//                             decoration: BoxDecoration(color: Colors.white.withOpacity(0.3)),
//                             child: Text(e, style: const TextStyle(fontSize: 12)),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//
//                 /////
//
//                 SizedBox(
//                   height: 60,
//                   child: ScrollablePositionedList.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: widget.geolocStateList.length,
//                     itemScrollController: itemScrollController,
//                     itemPositionsListener: itemPositionsListener,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5),
//                         child: GestureDetector(
//                           onTap: () {
//                             ref.read(appParamProvider.notifier).setIsMarkerShow(flag: false);
//
//                             // setState(() {
//                             //   /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドアワー）
//                             //   selectedHour = widget.geolocStateList[index].time.split(':')[0];
//                             //
//                             //   /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドタイムジオロック）
//                             //   selectedTimeGeoloc = widget.geolocStateList[index];
//                             // });
//                             //
//                             //
//                             //
//                             //
//
//                             /// ここでappParamProviderの変数を変更（セレクテッドアワー）
//                             ref
//                                 .read(appParamProvider.notifier)
//                                 .setSelectedHour(hour: widget.geolocStateList[index].time.split(':')[0]);
//
//                             /// ここでappParamProviderの変数を変更（セレクテッドタイムジオロック）
//                             ref
//                                 .read(appParamProvider.notifier)
//                                 .setSelectedTimeGeoloc(geoloc: widget.geolocStateList[index]);
//
//                             widget.mapController.move(
//                               LatLng(
//                                 widget.geolocStateList[index].latitude.toDouble(),
//                                 widget.geolocStateList[index].longitude.toDouble(),
//                               ),
//                               widget.currentZoom ?? widget.currentZoomEightTeen,
//                             );
//
//                             //
//                             // makePolylineGeolocList(geoloc: widget.geolocStateList[index]);
//                             //
//                             //
//                             //
//                             //
//                           },
//                           child: CircleAvatar(
//                             // ignore: use_if_null_to_convert_nulls_to_bools
//                             backgroundColor: (widget.displayTempMap == true)
//                                 ? Colors.orangeAccent.withOpacity(0.5)
//                                 : Colors.green[900]?.withOpacity(0.5),
//                             child: Text(
//                               widget.geolocStateList[index].time,
//                               style: const TextStyle(color: Colors.white, fontSize: 10),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//
//                 /////
//
//                 if (widget.templeInfoList != null) ...<Widget>[
//                   SingleChildScrollView(
//                     controller: scrollController,
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: widget.templeInfoList!.map((TempleInfoModel element) {
//                         return GestureDetector(
//                           onTap: () {
//                             //
//                             //
//                             //
//                             // setState(() {
//                             //   /// ここでConsumerStatefulWidgetの変数を変更（セレクテッドタイムジオロック）
//                             //   selectedTimeGeoloc = GeolocModel(
//                             //     id: 0,
//                             //     year: widget.geolocStateList[0].year,
//                             //     month: widget.geolocStateList[0].month,
//                             //     day: widget.geolocStateList[0].day,
//                             //     time: '',
//                             //     latitude: element.latitude,
//                             //     longitude: element.longitude,
//                             //   );
//                             //
//                             //   currentZoom = 17;
//                             //
//                             //   isTempleCircleShow = true;
//                             //
//                             //   currentCenter = LatLng(element.latitude.toDouble(), element.longitude.toDouble());
//                             // });
//
//                             widget.mapController.move(
//                               LatLng(element.latitude.toDouble(), element.longitude.toDouble()),
//                               widget.currentZoom ?? widget.currentZoomEightTeen,
//                             );
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.all(5),
//                             padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
//                             decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.3)),
//                             child: Text(element.temple, style: const TextStyle(fontSize: 12)),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//
//                 /////
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   ///
//   void setDefaultBoundsMap() {
//     if (widget.geolocStateList.length > 1) {
//       final LatLngBounds bounds = LatLngBounds.fromPoints(
//         <LatLng>[
//           LatLng(widget.minMaxLatLngMap['minLat']!, widget.minMaxLatLngMap['maxLng']!),
//           LatLng(widget.minMaxLatLngMap['maxLat']!, widget.minMaxLatLngMap['minLng']!),
//         ],
//       );
//
//       final CameraFit cameraFit =
//           CameraFit.bounds(bounds: bounds, padding: EdgeInsets.all(widget.currentPaddingIndex * 10));
//
//       widget.mapController.fitCamera(cameraFit);
//
//       /// これは残しておく
//       // final LatLng newCenter = mapController.camera.center;
//
//       final double newZoom = widget.mapController.camera.zoom;
//
//       ref.read(appParamProvider.notifier).setCurrentZoom(zoom: newZoom);
//
//       // setState(() => currentZoom = newZoom);
//       //
//       // getBoundsZoomValue = true;
//       //
//       //
//       //
//       //
//     }
//   }
// }
