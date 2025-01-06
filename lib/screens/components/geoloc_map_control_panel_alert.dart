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
import '../parts/geoloc_dialog.dart';
import 'visited_temple_time_circle_alert.dart';

class GeolocMapControlPanelAlert extends ConsumerStatefulWidget {
  const GeolocMapControlPanelAlert({
    super.key,
    required this.geolocStateList,
    required this.mapController,
    required this.currentZoomEightTeen,
    required this.selectedHourMap,
    this.templeInfoList,
    required this.minMaxLatLngMap,
    this.displayTempMap,
    required this.date,
  });

  final DateTime date;
  final List<GeolocModel> geolocStateList;
  final MapController mapController;
  final double currentZoomEightTeen;
  final Map<String, List<String>> selectedHourMap;
  final List<TempleInfoModel>? templeInfoList;
  final Map<String, double> minMaxLatLngMap;
  final bool? displayTempMap;

  @override
  ConsumerState<GeolocMapControlPanelAlert> createState() => _GeolocMapControlPanelAlertState();
}

class _GeolocMapControlPanelAlertState extends ConsumerState<GeolocMapControlPanelAlert> {
  late ScrollController scrollController;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

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

  ///
  @override
  Widget build(BuildContext context) {
    final List<String> timeList = <String>[];
    for (final GeolocModel element in widget.geolocStateList) {
      final List<String> exTime = element.time.split(':');
      if (!timeList.contains(exTime[0])) {
        timeList.add(exTime[0]);
      }
    }

    final AppParamsResponseState appParamState = ref.watch(appParamProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                /////

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () =>
                              ref.read(appParamProvider.notifier).setIsMarkerShow(flag: !appParamState.isMarkerShow),
                          child: const Icon(Icons.stacked_line_chart),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => setDefaultBoundsMap(),
                          child: const Icon(Icons.center_focus_strong),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            ///

                            if (widget.geolocStateList.length == 1 || appParamState.selectedTimeGeoloc != null) {
                              ref.read(appParamProvider.notifier).setCurrentZoom(zoom: appParamState.currentZoom + 1);

                              widget.mapController.move(
                                (appParamState.selectedTimeGeoloc == null)
                                    ? LatLng(
                                        widget.geolocStateList[0].latitude.toDouble(),
                                        widget.geolocStateList[0].longitude.toDouble(),
                                      )
                                    : LatLng(
                                        appParamState.selectedTimeGeoloc!.latitude.toDouble(),
                                        appParamState.selectedTimeGeoloc!.longitude.toDouble(),
                                      ),
                                appParamState.currentZoom + 1,
                              );
                            } else {
                              ref
                                  .read(appParamProvider.notifier)
                                  .setCurrentPaddingIndex(index: appParamState.currentPaddingIndex + 1);

                              setDefaultBoundsMap();
                            }

                            ///
                          },
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            ///

                            if (widget.geolocStateList.length == 1 || appParamState.selectedTimeGeoloc != null) {
                              ref.read(appParamProvider.notifier).setCurrentZoom(zoom: appParamState.currentZoom - 1);

                              widget.mapController.move(
                                (appParamState.selectedTimeGeoloc == null)
                                    ? LatLng(
                                        widget.geolocStateList[0].latitude.toDouble(),
                                        widget.geolocStateList[0].longitude.toDouble(),
                                      )
                                    : LatLng(
                                        appParamState.selectedTimeGeoloc!.latitude.toDouble(),
                                        appParamState.selectedTimeGeoloc!.longitude.toDouble(),
                                      ),
                                appParamState.currentZoom - 1,
                              );
                            } else {
                              int index = appParamState.currentPaddingIndex - 1;

                              if (index < 1) {
                                index = 1;
                              }

                              ref.read(appParamProvider.notifier).setCurrentPaddingIndex(index: index);

                              setDefaultBoundsMap();
                            }

                            ///
                          },
                          child: const Icon(Icons.remove),
                        ),
                      ],
                    ),
                  ],
                ),

                /////

                const SizedBox(height: 20),

                /////

                SingleChildScrollView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: timeList.map((String e) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            ref.read(appParamProvider.notifier).setSelectedTimeGeoloc(
                                geoloc: widget.geolocStateList
                                    .firstWhere((GeolocModel e2) => e2.time == widget.selectedHourMap[e]?[0]));

                            itemScrollController.jumpTo(
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
                    itemScrollController: itemScrollController,
                    itemPositionsListener: itemPositionsListener,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            ref.read(appParamProvider.notifier).setIsMarkerShow(flag: true);

                            ref
                                .read(appParamProvider.notifier)
                                .setSelectedTimeGeoloc(geoloc: widget.geolocStateList[index]);

                            widget.mapController.move(
                              LatLng(
                                widget.geolocStateList[index].latitude.toDouble(),
                                widget.geolocStateList[index].longitude.toDouble(),
                              ),
                              appParamState.currentZoom,
                            );

                            ref
                                .read(appParamProvider.notifier)
                                .setPolylineGeolocModel(model: widget.geolocStateList[index]);

                            itemScrollController.jumpTo(index: index);
                          },
                          child: CircleAvatar(
                            backgroundColor: (appParamState.selectedTimeGeoloc != null &&
                                    appParamState.selectedTimeGeoloc!.time == widget.geolocStateList[index].time)
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
                  ),
                ),

                /////

                if (widget.templeInfoList != null) ...<Widget>[
                  SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: widget.templeInfoList!.map((TempleInfoModel element) {
                        return GestureDetector(
                          onTap: () {
                            ref.read(appParamProvider.notifier).setSelectedTimeGeoloc(
                                  geoloc: GeolocModel(
                                    id: 0,
                                    year: widget.geolocStateList[0].year,
                                    month: widget.geolocStateList[0].month,
                                    day: widget.geolocStateList[0].day,
                                    time: '',
                                    latitude: element.latitude,
                                    longitude: element.longitude,
                                  ),
                                );

                            ref.read(appParamProvider.notifier).setCurrentZoom(zoom: 17);

                            ref.read(appParamProvider.notifier).setIsTempleCircleShow(flag: true);

                            ref.read(appParamProvider.notifier).setCurrentCenter(
                                latLng: LatLng(element.latitude.toDouble(), element.longitude.toDouble()));

                            ref.read(appParamProvider.notifier).setSelectedTemple(temple: element);

                            widget.mapController
                                .move(LatLng(element.latitude.toDouble(), element.longitude.toDouble()), 17);

                            GeolocDialog(
                              context: context,
                              widget: VisitedTempleTimeCircleAlert(
                                date: widget.date,
                                temple: element,
                                geolocStateList: widget.geolocStateList,
                                displayTempMap: widget.displayTempMap,
                                mapController: widget.mapController,
                                itemScrollController: itemScrollController,
                              ),
                              paddingTop: context.screenSize.height * 0.1,
                              paddingBottom: context.screenSize.height * 0.25,
                              paddingLeft: context.screenSize.width * 0.5,
                              clearBarrierColor: true,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                            decoration: BoxDecoration(
                              color: (appParamState.selectedTemple != null &&
                                      element.temple == appParamState.selectedTemple!.temple)
                                  ? Colors.orangeAccent.withOpacity(0.3)
                                  : Colors.redAccent.withOpacity(0.3),
                            ),
                            child: Text(element.temple, style: const TextStyle(fontSize: 12)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],

                /////
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  void setDefaultBoundsMap() {
    if (widget.geolocStateList.length > 1) {
      final int currentPaddingIndex =
          ref.watch(appParamProvider.select((AppParamsResponseState value) => value.currentPaddingIndex));

      final LatLngBounds bounds = LatLngBounds.fromPoints(
        <LatLng>[
          LatLng(widget.minMaxLatLngMap['minLat']!, widget.minMaxLatLngMap['maxLng']!),
          LatLng(widget.minMaxLatLngMap['maxLat']!, widget.minMaxLatLngMap['minLng']!),
        ],
      );

      final CameraFit cameraFit = CameraFit.bounds(bounds: bounds, padding: EdgeInsets.all(currentPaddingIndex * 10));

      widget.mapController.fitCamera(cameraFit);

      /// これは残しておく
      // final LatLng newCenter = mapController.camera.center;

      final double newZoom = widget.mapController.camera.zoom;

      ref.read(appParamProvider.notifier).setCurrentZoom(zoom: newZoom);
    }
  }
}
