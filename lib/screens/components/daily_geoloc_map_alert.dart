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

  List<GeolocModel> polylineGeolocList = <GeolocModel>[];

  late ScrollController _scrollController;

  final ItemScrollController controller = ItemScrollController();
  final ItemPositionsListener listener = ItemPositionsListener.create();

  double currentZoom = 18;

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
                const SizedBox(height: 10),
                displayMapHeadTimeSelect(),
                const SizedBox(height: 10),
                Expanded(
                  child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
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

                      if (!isMarkerHide) ...<Widget>[
                        MarkerLayer(markers: markerList),
                      ],

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
                displayMapBottomZoomChangeButton(),
              ],
            ),
          ),
          SizedBox(
              width: 60,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  Expanded(child: displayTimeCircleAvatar()),
                ],
              )),
        ],
      ),
    );
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

    return Row(
      children: <Widget>[
        const SizedBox(width: 10),

        /////

        OutlinedButton(
          style:
              OutlinedButton.styleFrom(padding: EdgeInsets.zero, backgroundColor: Colors.pinkAccent.withOpacity(0.1)),
          onPressed: () {
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
                      controller.jumpTo(
                        index:
                            widget.geolocStateList.indexWhere((GeolocModel element) => element.time.split(':')[0] == e),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.2),
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
            setState(() {
              polylineGeolocList = (!isMarkerHide) ? widget.geolocStateList : <GeolocModel>[];
            });

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
                                    selectedTimeGeoloc.latitude.toDouble(),
                                    selectedTimeGeoloc.longitude.toDouble(),
                                  ),
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
                                    selectedTimeGeoloc.latitude.toDouble(),
                                    selectedTimeGeoloc.longitude.toDouble(),
                                  ),
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

        /*


        //------------------------//

        if (selectedTimeGeoloc == null)
          Container()
        else
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
                              LatLng(
                                selectedTimeGeoloc.latitude.toDouble(),
                                selectedTimeGeoloc.longitude.toDouble(),
                              ),
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
                              LatLng(
                                selectedTimeGeoloc.latitude.toDouble(),
                                selectedTimeGeoloc.longitude.toDouble(),
                              ),
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

        //------------------------//




        */
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
