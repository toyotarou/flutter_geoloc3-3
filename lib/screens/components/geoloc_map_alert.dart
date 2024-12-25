import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../controllers/app_params/app_params_notifier.dart';
import '../../controllers/app_params/app_params_response_state.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../utilities/tile_provider.dart';

class GeolocMapAlert extends ConsumerStatefulWidget {
  const GeolocMapAlert({super.key, required this.geolocStateList, this.displayTempMap, required this.displayMonthMap});

  final List<GeolocModel> geolocStateList;

  final bool? displayTempMap;

  final bool displayMonthMap;

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

  List<GeolocModel> polylineGeolocList = <GeolocModel>[];

  late ScrollController _scrollController;

  final ItemScrollController controller = ItemScrollController();
  final ItemPositionsListener listener = ItemPositionsListener.create();

  double currentZoom = 18;

  Map<String, List<String>> selectedHourMap = <String, List<String>>{};

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

  ///
  void _scrollToTop() {
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  ///
  @override
  Widget build(BuildContext context) {
    makeSelectedHourMap();

    makeMinMaxLatLng();

    makeMarker();

    final bool isMarkerHide = ref.watch(appParamProvider.select((AppParamsResponseState value) => value.isMarkerHide));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (!widget.displayMonthMap) ...<Widget>[
                  const SizedBox(height: 10),
                  displayMapHeadTimeSelect(),
                  const SizedBox(height: 10),
                ],
                Expanded(
                  child: FlutterMap(
                    mapController: mapController,
                    options: (widget.geolocStateList.length == 1)
                        ? MapOptions(
                            initialCenter: LatLng(widget.geolocStateList[0].latitude.toDouble(),
                                widget.geolocStateList[0].longitude.toDouble()),
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

                      if (!isMarkerHide) ...<Widget>[MarkerLayer(markers: markerList)],

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
                ),
                if (!widget.displayMonthMap) ...<Widget>[displayMapBottomZoomChangeButton()],
              ],
            ),
          ),
          if (!widget.displayMonthMap) ...<Widget>[
            SizedBox(
              width: 60,
              child: Column(children: <Widget>[const SizedBox(height: 10), Expanded(child: displayTimeCircleAvatar())]),
            ),
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
  Widget displayMapHeadTimeSelect() {
    final List<String> timeList = <String>[];

    for (final GeolocModel element in widget.geolocStateList) {
      final List<String> exTime = element.time.split(':');

      if (!timeList.contains(exTime[0])) {
        timeList.add(exTime[0]);
      }
    }

    final String selectedHour =
        ref.watch(appParamProvider.select((AppParamsResponseState value) => value.selectedHour));

    return Row(
      children: <Widget>[
        const SizedBox(width: 10),

        /////

        OutlinedButton(
          style:
              OutlinedButton.styleFrom(padding: EdgeInsets.zero, backgroundColor: Colors.pinkAccent.withOpacity(0.1)),
          onPressed: () {
            ref.read(appParamProvider.notifier).setSelectedHour(hour: '');

            ref.read(appParamProvider.notifier).setSelectedTimeGeoloc();

            polylineGeolocList = <GeolocModel>[];

            controller.jumpTo(index: 0);

            _scrollToTop();
          },
          child: const Text('clear', style: TextStyle(color: Colors.white)),
        ),

        /////

        const SizedBox(width: 10),

        /////

        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: timeList.map((String e) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      ref.read(appParamProvider.notifier).setSelectedHour(hour: e);

                      ref.read(appParamProvider.notifier).setSelectedTimeGeoloc(
                            geoloc: widget.geolocStateList
                                .firstWhere((GeolocModel e2) => e2.time == selectedHourMap[e]?[0]),
                          );

                      controller.jumpTo(
                        index:
                            widget.geolocStateList.indexWhere((GeolocModel element) => element.time.split(':')[0] == e),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor:
                          (e == selectedHour) ? Colors.yellowAccent.withOpacity(0.3) : Colors.white.withOpacity(0.3),
                      child: Text(e, style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        /////
      ],
    );
  }

  ///
  Widget displayMapBottomZoomChangeButton() {
    final GeolocModel? selectedTimeGeoloc =
        ref.watch(appParamProvider.select((AppParamsResponseState value) => value.selectedTimeGeoloc));

    final bool isMarkerHide = ref.watch(appParamProvider.select((AppParamsResponseState value) => value.isMarkerHide));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          onPressed: () {
            setState(() => polylineGeolocList = (!isMarkerHide) ? widget.geolocStateList : <GeolocModel>[]);

            ref.read(appParamProvider.notifier).setIsMarkerHide(flag: !isMarkerHide);
          },
          icon: const Icon(Icons.stacked_line_chart),
        ),
        Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(),
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.redAccent.withOpacity(0.5),
                      child: IconButton(
                        onPressed: () {
                          setState(() => currentZoom += 1);

                          mapController.move(
                            (selectedTimeGeoloc == null)
                                ? LatLng(
                                    widget.geolocStateList[0].latitude.toDouble(),
                                    widget.geolocStateList[0].longitude.toDouble(),
                                  )
                                : LatLng(
                                    selectedTimeGeoloc.latitude.toDouble(), selectedTimeGeoloc.longitude.toDouble()),
                            currentZoom,
                          );
                        },
                        icon: const Icon(Icons.plus_one, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: Colors.redAccent.withOpacity(0.5),
                      child: IconButton(
                        onPressed: () {
                          setState(() => currentZoom -= 1);

                          mapController.move(
                            (selectedTimeGeoloc == null)
                                ? LatLng(
                                    widget.geolocStateList[0].latitude.toDouble(),
                                    widget.geolocStateList[0].longitude.toDouble(),
                                  )
                                : LatLng(
                                    selectedTimeGeoloc.latitude.toDouble(), selectedTimeGeoloc.longitude.toDouble()),
                            currentZoom,
                          );
                        },
                        icon: const Icon(Icons.exposure_minus_1, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ],
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
  Widget displayTimeCircleAvatar() {
    final GeolocModel? selectedTimeGeoloc =
        ref.watch(appParamProvider.select((AppParamsResponseState value) => value.selectedTimeGeoloc));

    final String selectedHour =
        ref.watch(appParamProvider.select((AppParamsResponseState value) => value.selectedHour));

    return ScrollablePositionedList.builder(
      itemCount: widget.geolocStateList.length,
      itemScrollController: controller,
      itemPositionsListener: listener,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () {
              ref.read(appParamProvider.notifier).setIsMarkerHide(flag: false);

              ref.read(appParamProvider.notifier).setSelectedTimeGeoloc(geoloc: widget.geolocStateList[index]);

              ref
                  .read(appParamProvider.notifier)
                  .setSelectedHour(hour: widget.geolocStateList[index].time.split(':')[0]);

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
              backgroundColor:
                  (selectedTimeGeoloc != null && selectedTimeGeoloc.time == widget.geolocStateList[index].time)
                      ? Colors.redAccent.withOpacity(0.5)
                      // ignore: use_if_null_to_convert_nulls_to_bools
                      : (widget.geolocStateList[index].time.split(':')[0] == selectedHour)
                          ? Colors.yellowAccent.withOpacity(0.3)
                          // ignore: use_if_null_to_convert_nulls_to_bools
                          : (widget.displayTempMap == true)
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
    );
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
