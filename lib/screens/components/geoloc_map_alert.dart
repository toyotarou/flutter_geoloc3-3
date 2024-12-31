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

// ignore: must_be_immutable
class GeolocMapAlert extends ConsumerStatefulWidget {
  GeolocMapAlert({
    super.key,
    required this.geolocStateList,
    this.displayTempMap,
    required this.displayMonthMap,
    required this.walkRecord,
    this.templeInfoList,
  });

  final List<GeolocModel> geolocStateList;
  final bool? displayTempMap;
  final bool displayMonthMap;
  final WalkRecordModel walkRecord;
  List<TempleInfoModel>? templeInfoList;

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

  double currentZoom = 18;

  bool isBottomSheetVisible = false;

  List<Marker> markerList = <Marker>[];

  late ScrollController _scrollController;
  final ItemScrollController controller = ItemScrollController();
  final ItemPositionsListener listener = ItemPositionsListener.create();

  List<GeolocModel> polylineGeolocList = <GeolocModel>[];

  Map<String, List<String>> selectedHourMap = <String, List<String>>{};

  bool isMarkerShow = true;

  GeolocModel? selectedTimeGeoloc;

  String selectedHour = '';

  ///
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
  }

  ///
  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  // ///
  // void _scrollToTop() {
  //   _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  // }

  ///
  @override
  Widget build(BuildContext context) {
    makeSelectedHourMap();

    makeMinMaxLatLng();

    makeMarker();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: (widget.geolocStateList.length == 1)
                ? MapOptions(
                    initialCenter: LatLng(
                      widget.geolocStateList[0].latitude.toDouble(),
                      widget.geolocStateList[0].longitude.toDouble(),
                    ),
                    initialZoom: currentZoom)
                : MapOptions(
                    initialCameraFit: CameraFit.bounds(
                      bounds: LatLngBounds.fromPoints(<LatLng>[LatLng(minLat, maxLng), LatLng(maxLat, minLng)]),
                      padding: const EdgeInsets.all(50),
                    ),
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
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
              child: IconButton(onPressed: () => showBottomSheet(context), icon: const Icon(Icons.info)),
            ),
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
  void showBottomSheet(BuildContext context) {
    final List<String> timeList = <String>[];
    for (final GeolocModel element in widget.geolocStateList) {
      final List<String> exTime = element.time.split(':');
      if (!timeList.contains(exTime[0])) {
        timeList.add(exTime[0]);
      }
    }

    // ignore: inference_failure_on_function_invocation
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.black.withOpacity(0.6),

      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              /////

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isMarkerShow = !isMarkerShow;

                        polylineGeolocList = (!isMarkerShow) ? widget.geolocStateList : <GeolocModel>[];

                        selectedHour = '';

                        selectedTimeGeoloc = null;
                      });
                    },
                    child: const Icon(Icons.stacked_line_chart),
                  ),
                  Container(),
                ],
              ),

              /////

              const SizedBox(height: 20),

              /////

              SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: timeList.map((String e) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedHour = e;

                            selectedTimeGeoloc = widget.geolocStateList
                                .firstWhere((GeolocModel e2) => e2.time == selectedHourMap[e]?[0]);
                          });

                          ref.read(appParamProvider.notifier).setSelectedHour(hour: e);

                          ref.read(appParamProvider.notifier).setSelectedTimeGeoloc(
                              geoloc: widget.geolocStateList
                                  .firstWhere((GeolocModel e2) => e2.time == selectedHourMap[e]?[0]));

                          controller.jumpTo(
                            index: widget.geolocStateList
                                .indexWhere((GeolocModel element) => element.time.split(':')[0] == e),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.3)),
                          child: Text(e, style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              /////

              SizedBox(
                height: 60,
                child: ScrollablePositionedList.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.geolocStateList.length,
                  itemScrollController: controller,
                  itemPositionsListener: listener,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                        onTap: () {
                          ref.read(appParamProvider.notifier).setIsMarkerHide(flag: false);

                          setState(() {
                            selectedHour = widget.geolocStateList[index].time.split(':')[0];

                            selectedTimeGeoloc = widget.geolocStateList[index];
                          });

                          ref
                              .read(appParamProvider.notifier)
                              .setSelectedHour(hour: widget.geolocStateList[index].time.split(':')[0]);

                          ref
                              .read(appParamProvider.notifier)
                              .setSelectedTimeGeoloc(geoloc: widget.geolocStateList[index]);

                          mapController.move(
                            LatLng(
                              widget.geolocStateList[index].latitude.toDouble(),
                              widget.geolocStateList[index].longitude.toDouble(),
                            ),
                            currentZoom,
                          );

                          makePolylineGeolocList(geoloc: widget.geolocStateList[index]);
                        },
                        child: CircleAvatar(
                          // ignore: use_if_null_to_convert_nulls_to_bools
                          backgroundColor: (widget.displayTempMap == true)
                              ? Colors.orangeAccent.withOpacity(0.5)
                              : Colors.green[900]?.withOpacity(0.5),
                          child: Text(
                            widget.geolocStateList[index].time,
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              /////

              if (widget.templeInfoList != null) ...<Widget>[
                SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widget.templeInfoList!.map((TempleInfoModel element) {
                      return Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                        decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.3)),
                        child: Text(element.temple, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                  ),
                ),
              ],

              /////
            ],
          ),
        );
      },
      // ignore: always_specify_types
    ).then((value) => setState(() => isBottomSheetVisible = false));

    setState(() => isBottomSheetVisible = true);
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
