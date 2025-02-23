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
import '../../models/temple_photo_model.dart';
import '../../screens/components/temple_photo_display_alert.dart';
import '../../screens/parts/geoloc_dialog.dart';
import '../../screens/parts/geoloc_overlay.dart';
import '../../utilities/utilities.dart';
import 'geoloc_map_control_panel_widget.dart';

///
mixin GeolocMapControlPanelAlertMixin on ConsumerState<GeolocMapControlPanelWidget> {
  late ScrollController scrollController;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  RangeValues currentRange = const RangeValues(0, 23);

  final List<OverlayEntry> _bigEntries = <OverlayEntry>[];
  final List<OverlayEntry> _firstEntries = <OverlayEntry>[];
  final List<OverlayEntry> _secondEntries = <OverlayEntry>[];

  Utility utility = Utility();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  ///
  Widget buildContent(BuildContext context) {
    final AppParamNotifier appParamNotifier = ref.read(appParamProvider.notifier);
    final AppParamsResponseState appParamState = ref.watch(appParamProvider);

    final List<String> timeList = <String>[];
    for (final GeolocModel element in widget.geolocStateList) {
      final List<String> exTime = element.time.split(':');
      if (!timeList.contains(exTime[0])) {
        timeList.add(exTime[0]);
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //============================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => appParamNotifier.setIsMarkerShow(flag: !appParamState.isMarkerShow),
                          child: const Icon(Icons.stacked_line_chart),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            appParamNotifier.setSelectedTimeGeoloc();
                            setDefaultBoundsMap();
                          },
                          child: const Icon(Icons.center_focus_strong),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            // ignore: use_if_null_to_convert_nulls_to_bools
                            backgroundColor: (widget.displayTempMap == true)
                                ? Colors.orangeAccent.withOpacity(0.2)
                                : Colors.green[900]?.withOpacity(0.2),
                          ),
                          onPressed: () {
                            if (widget.geolocStateList.length == 1 || appParamState.selectedTimeGeoloc != null) {
                              appParamNotifier.setCurrentZoom(zoom: appParamState.currentZoom + 1);

                              widget.mapController.move(
                                (appParamState.selectedTimeGeoloc == null)
                                    ? LatLng(widget.geolocStateList[0].latitude.toDouble(),
                                        widget.geolocStateList[0].longitude.toDouble())
                                    : LatLng(appParamState.selectedTimeGeoloc!.latitude.toDouble(),
                                        appParamState.selectedTimeGeoloc!.longitude.toDouble()),
                                appParamState.currentZoom + 1,
                              );
                            } else {
                              appParamNotifier.setCurrentPaddingIndex(index: appParamState.currentPaddingIndex + 1);
                              setDefaultBoundsMap();
                            }
                          },
                          child: const Column(
                            children: <Widget>[Text('広域', style: TextStyle(color: Colors.white, fontSize: 10))],
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            // ignore: use_if_null_to_convert_nulls_to_bools
                            backgroundColor: (widget.displayTempMap == true)
                                ? Colors.orangeAccent.withOpacity(0.2)
                                : Colors.green[900]?.withOpacity(0.2),
                          ),
                          onPressed: () {
                            if (widget.geolocStateList.length == 1 || appParamState.selectedTimeGeoloc != null) {
                              appParamNotifier.setCurrentZoom(zoom: appParamState.currentZoom - 1);

                              widget.mapController.move(
                                (appParamState.selectedTimeGeoloc == null)
                                    ? LatLng(widget.geolocStateList[0].latitude.toDouble(),
                                        widget.geolocStateList[0].longitude.toDouble())
                                    : LatLng(appParamState.selectedTimeGeoloc!.latitude.toDouble(),
                                        appParamState.selectedTimeGeoloc!.longitude.toDouble()),
                                appParamState.currentZoom - 1,
                              );
                            } else {
                              int index = appParamState.currentPaddingIndex - 1;
                              if (index < 1) {
                                index = 1;
                              }
                              appParamNotifier.setCurrentPaddingIndex(index: index);
                              setDefaultBoundsMap();
                            }
                          },
                          child: const Column(
                            children: <Widget>[Text('狭域', style: TextStyle(color: Colors.white, fontSize: 10))],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                //============================================
                const SizedBox(height: 20),
                //============================================
                SingleChildScrollView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: timeList.map((String e) {
                      if (appParamState.timeGeolocDisplayStart != -1 && appParamState.timeGeolocDisplayEnd != -1) {
                        final int num = int.parse(e);
                        if (num < appParamState.timeGeolocDisplayStart || num > appParamState.timeGeolocDisplayEnd) {
                          return Container();
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            appParamNotifier.setSelectedTimeGeoloc(
                              geoloc: widget.geolocStateList
                                  .firstWhere((GeolocModel e2) => e2.time == widget.selectedHourMap[e]?[0]),
                            );
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
                //============================================
                SizedBox(
                  height: 60,
                  child: ScrollablePositionedList.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.geolocStateList.length,
                    itemScrollController: itemScrollController,
                    itemPositionsListener: itemPositionsListener,
                    itemBuilder: (BuildContext context, int index) {
                      if (appParamState.timeGeolocDisplayStart != -1 && appParamState.timeGeolocDisplayEnd != -1) {
                        final int num = int.parse(widget.geolocStateList[index].time.split(':')[0]);
                        if (num < appParamState.timeGeolocDisplayStart || num > appParamState.timeGeolocDisplayEnd) {
                          return Container();
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            appParamNotifier.setIsMarkerShow(flag: true);
                            appParamNotifier.setSelectedTimeGeoloc(geoloc: widget.geolocStateList[index]);

                            widget.mapController.move(
                              LatLng(widget.geolocStateList[index].latitude.toDouble(),
                                  widget.geolocStateList[index].longitude.toDouble()),
                              appParamState.currentZoom,
                            );

                            appParamNotifier.setPolylineGeolocModel(model: widget.geolocStateList[index]);

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
                            child: Text(widget.geolocStateList[index].time,
                                style: const TextStyle(color: Colors.white, fontSize: 10)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                //============================================
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          // ignore: use_if_null_to_convert_nulls_to_bools
                          thumbColor: (widget.displayTempMap == true)
                              ? Colors.orangeAccent.withOpacity(0.2)
                              : Colors.green[900]?.withOpacity(0.2),
                          // ignore: use_if_null_to_convert_nulls_to_bools
                          activeTrackColor: (widget.displayTempMap == true)
                              ? Colors.orangeAccent.withOpacity(0.2)
                              : Colors.green[900]?.withOpacity(0.2),
                          inactiveTrackColor: Colors.white,
                        ),
                        child: RangeSlider(
                          values: currentRange,
                          max: 23,
                          divisions: 23,
                          labels:
                              RangeLabels(currentRange.start.round().toString(), currentRange.end.round().toString()),
                          onChanged: (RangeValues newRange) => setState(() => currentRange = newRange),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        // ignore: use_if_null_to_convert_nulls_to_bools
                        backgroundColor: (widget.displayTempMap == true)
                            ? Colors.orangeAccent.withOpacity(0.2)
                            : Colors.green[900]?.withOpacity(0.2),
                      ),
                      onPressed: () => appParamNotifier.setTimeGeolocDisplay(
                          start: currentRange.start.round(), end: currentRange.end.round()),
                      child: const Column(children: <Widget>[Text('set', style: TextStyle(color: Colors.white))]),
                    ),
                  ],
                ),
                //============================================
                if (widget.templeInfoList != null) ...<Widget>[
                  SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: widget.templeInfoList!.map((TempleInfoModel element) {
                        return GestureDetector(
                          onTap: () {
                            appParamNotifier.setSelectedTimeGeoloc(
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

                            appParamNotifier.setCurrentZoom(zoom: 17);

                            appParamNotifier.setIsTempleCircleShow(flag: true);

                            appParamNotifier.setCurrentCenter(
                                latLng: LatLng(element.latitude.toDouble(), element.longitude.toDouble()));

                            appParamNotifier.setSelectedTemple(temple: element);

                            appParamNotifier.setTempleGeolocTimeCircleAvatarParams(
                                bigEntries: _bigEntries, setStateCallback: setState);

                            widget.mapController
                                .move(LatLng(element.latitude.toDouble(), element.longitude.toDouble()), 17);

                            TemplePhotoModel templePhoto =
                                TemplePhotoModel(date: DateTime.now(), temple: '', templephotos: <String>[]);

                            if (widget.templePhotoDateList.isNotEmpty) {
                              templePhoto = widget.templePhotoDateList.firstWhere(
                                (TemplePhotoModel element2) => element2.temple == element.temple,
                                orElse: () => templePhoto,
                              );
                            }

                            appParamNotifier.setFirstOverlayParams(firstEntries: _firstEntries);

                            addFirstOverlay(
                              context: context,
                              setStateCallback: setState,
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 390,
                              color: Colors.blueGrey.withOpacity(0.3),
                              initialPosition: Offset(MediaQuery.of(context).size.width * 0.7, 160),
                              widget: Consumer(
                                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                                  return displayTempleGeolocTimeCircleAvatarList(
                                      temple: element, templephotos: templePhoto.templephotos);
                                },
                              ),
                              firstEntries: _firstEntries,
                              secondEntries: _secondEntries,
                              onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
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
                //============================================
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  void setDefaultBoundsMap() {
    final AppParamNotifier appParamNotifier = ref.read(appParamProvider.notifier);
    final AppParamsResponseState appParamState = ref.watch(appParamProvider);

    if (widget.geolocStateList.length > 1) {
      final LatLngBounds bounds = LatLngBounds.fromPoints(
        <LatLng>[
          LatLng(widget.minMaxLatLngMap['minLat']!, widget.minMaxLatLngMap['maxLng']!),
          LatLng(widget.minMaxLatLngMap['maxLat']!, widget.minMaxLatLngMap['minLng']!),
        ],
      );

      final CameraFit cameraFit =
          CameraFit.bounds(bounds: bounds, padding: EdgeInsets.all(appParamState.currentPaddingIndex * 10));

      widget.mapController.fitCamera(cameraFit);

      final double newZoom = widget.mapController.camera.zoom;
      appParamNotifier.setCurrentZoom(zoom: newZoom);
    }
  }

  ///
  Widget displayTempleGeolocTimeCircleAvatarList(
      {required TempleInfoModel temple, required List<String> templephotos}) {
    final AppParamNotifier appParamNotifier = ref.read(appParamProvider.notifier);
    final AppParamsResponseState appParamState = ref.watch(appParamProvider);

    final List<Widget> list = <Widget>[];

    for (final GeolocModel element in widget.geolocStateList) {
      final double dist = utility.calculateDistance(
        LatLng(temple.latitude.toDouble(), temple.longitude.toDouble()),
        LatLng(element.latitude.toDouble(), element.longitude.toDouble()),
      );

      if (dist <= 100.0) {
        list.add(
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor:
                  (appParamState.selectedTimeGeoloc != null && appParamState.selectedTimeGeoloc!.time == element.time)
                      ? Colors.redAccent.withOpacity(0.5)
                      // ignore: use_if_null_to_convert_nulls_to_bools
                      : (widget.displayTempMap == true)
                          ? Colors.orangeAccent.withOpacity(0.2)
                          : Colors.green[900]?.withOpacity(0.2),
            ),
            onPressed: () {
              appParamNotifier.setIsMarkerShow(flag: true);
              appParamNotifier.setSelectedTimeGeoloc(
                geoloc: GeolocModel(
                  id: 0,
                  year: widget.date.yyyymmdd.split('-')[0],
                  month: widget.date.yyyymmdd.split('-')[1],
                  day: widget.date.yyyymmdd.split('-')[2],
                  time: element.time,
                  latitude: element.latitude,
                  longitude: element.longitude,
                ),
              );
              widget.mapController
                  .move(LatLng(element.latitude.toDouble(), element.longitude.toDouble()), appParamState.currentZoom);
              final int pos = widget.geolocStateList.indexWhere(
                (GeolocModel element2) => element2.time == element.time,
              );
              itemScrollController.jumpTo(index: pos);
            },
            child: Column(
              children: <Widget>[
                Text(element.time, style: const TextStyle(color: Colors.white, fontSize: 10)),
                Container(width: MediaQuery.of(context).size.width),
              ],
            ),
          ),
        );
      }
    }

    return SizedBox(
      height: 350,
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SingleChildScrollView(physics: const BouncingScrollPhysics(), child: Column(children: list)),
            ),
          ),
          if (templephotos.isNotEmpty) ...<Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(),
                IconButton(
                  onPressed: () {
                    GeolocDialog(
                      context: context,
                      widget: TemplePhotoDisplayAlert(templephotos: templephotos),
                      clearBarrierColor: true,
                    );
                  },
                  icon: const Icon(Icons.photo),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
