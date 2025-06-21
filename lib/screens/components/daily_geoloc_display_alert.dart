import 'package:flutter/material.dart';

import '../../collections/geoloc.dart';
import '../../collections/kotlin_room_data.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../models/temple_latlng_model.dart';
import '../../models/walk_record_model.dart';
import '../../ripository/geolocs_repository.dart';
import '../../utilities/utilities.dart';
import '../home_screen.dart';
import '../parts/error_dialog.dart';
import '../parts/geoloc_dialog.dart';
import 'pickup_geoloc_display_alert.dart';

class DailyGeolocDisplayAlert extends StatefulWidget {
  const DailyGeolocDisplayAlert(
      {super.key,
      required this.date,
      required this.geolocStateList,
      required this.walkRecord,
      this.templeInfoMap,
      this.kotlinRoomDataList});

  final DateTime date;
  final List<GeolocModel> geolocStateList;
  final WalkRecordModel walkRecord;
  final List<TempleInfoModel>? templeInfoMap;
  final List<KotlinRoomData>? kotlinRoomDataList;

  @override
  State<DailyGeolocDisplayAlert> createState() => _DailyGeolocDisplayAlertState();
}

class _DailyGeolocDisplayAlertState extends State<DailyGeolocDisplayAlert> {
  List<Geoloc>? geolocList = <Geoloc>[];

  List<Geoloc> pickupGeolocList = <Geoloc>[];

  String diffSeconds = '';

  Utility utility = Utility();

  Map<String, List<Geoloc>> geolocMap = <String, List<Geoloc>>{};

  bool isLoading = false;

  ///
  void _init() => _makeGeolocList();

  ///
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    Future(_init);

    makeDiffSeconds();

    makePickupGeolocList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Container(width: context.screenSize.width),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.date.yyyymmdd),
                          const SizedBox(height: 10),
                          Text(
                              (widget.kotlinRoomDataList != null) ? widget.kotlinRoomDataList!.length.toString() : '0'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              bool errFlg = false;
                              String contentStr = '';

                              if (widget.geolocStateList.isEmpty) {
                                errFlg = true;
                                contentStr = 'mysqlデータがありません。';
                              }

                              if (geolocMap.isEmpty) {
                                errFlg = true;
                                contentStr = 'geolocMapが作成されていません。';
                              }

                              if (errFlg) {
                                // ignore: always_specify_types
                                Future.delayed(
                                  Duration.zero,
                                  () => error_dialog(
                                    // ignore: use_build_context_synchronously
                                    context: context,
                                    title: 'isarデータを削除できません。',
                                    content: contentStr,
                                  ),
                                );

                                return;
                              }

                              _showDeleteDialog(geolocList: geolocMap[widget.date.yyyymmdd]);
                            },
                            child: Column(
                              children: <Widget>[
                                const Text('delete'),
                                Icon(Icons.delete,
                                    color: (widget.geolocStateList.isEmpty) ? Colors.grey : Colors.lightBlueAccent),
                                const Text('isar'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 30),
                          GestureDetector(
                            onTap: () {
                              GeolocDialog(
                                // ignore: use_build_context_synchronously
                                context: context,
                                widget: PickupGeolocDisplayAlert(
                                  date: widget.date,
                                  pickupGeolocList: pickupGeolocList,
                                  walkRecord: widget.walkRecord,
                                  templeInfoMap: widget.templeInfoMap,
                                ),
                              );
                            },
                            child: const Column(children: <Widget>[Text('select'), Icon(Icons.list), Text('list')]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(color: Colors.white.withOpacity(0.5), thickness: 5),
                  Expanded(child: displayGeolocList()),
                  Divider(color: Colors.white.withOpacity(0.5), thickness: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[const SizedBox.shrink(), Text(diffSeconds)],
                  ),
                ],
              ),
            ),
          ),
          if (isLoading) ...<Widget>[const Center(child: CircularProgressIndicator())],
        ],
      ),
    );
  }

  ///
  Future<void> _makeGeolocList() async {
    geolocMap = <String, List<Geoloc>>{};

    GeolocRepository().getAllIsarGeoloc().then(
      (List<Geoloc>? value) {
        if (mounted) {
          setState(
            () {
              geolocList = value;

              if (value!.isNotEmpty) {
                for (final Geoloc element in value) {
                  (geolocMap[element.date] ??= <Geoloc>[]).add(element);
                }
              }
            },
          );
        }
      },
    );
  }

  ///
  Widget displayGeolocList() {
    final List<Widget> list = <Widget>[];

    geolocList?.forEach(
      (Geoloc element) {
        if (widget.date.yyyymmdd == element.date) {
          list.add(
            DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 50,
                    child: Text(
                      element.id.toString(),
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                  SizedBox(width: 50, child: Text(element.time)),
                  const SizedBox(width: 20),
                  Expanded(child: Text(element.latitude)),
                  Expanded(child: Text(element.longitude)),
                ],
              ),
            ),
          );
        }
      },
    );

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) => list[index], childCount: list.length),
        ),
      ],
    );
  }

  ///
  Future<void> makePickupGeolocList() async {
    pickupGeolocList = <Geoloc>[];

    String keepLat = '';
    String keepLng = '';

    geolocMap[widget.date.yyyymmdd]
      ?..sort((Geoloc a, Geoloc b) => a.time.compareTo(b.time))
      ..forEach(
        (Geoloc element) {
          if (<String>{keepLat, keepLng, element.latitude, element.longitude}.toList().length >= 3) {
            pickupGeolocList.add(element);
          }

          keepLat = element.latitude;
          keepLng = element.longitude;
        },
      );
  }

  ///
  void makeDiffSeconds() {
    GeolocRepository().getRecentOneGeoloc().then(
      (Geoloc? value) {
        int secondDiff = 0;

        if (value != null) {
          secondDiff = DateTime.now()
              .difference(
                DateTime(
                  value.date.split('-')[0].toInt(),
                  value.date.split('-')[1].toInt(),
                  value.date.split('-')[2].toInt(),
                  value.time.split(':')[0].toInt(),
                  value.time.split(':')[1].toInt(),
                  value.time.split(':')[2].toInt(),
                ),
              )
              .inSeconds;
        }

        diffSeconds = secondDiff.toString().padLeft(2, '0');
      },
    );
  }

  ///
  void _showDeleteDialog({List<Geoloc>? geolocList}) {
    final Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
        onPressed: () {
          _deleteGeolocList(geolocList: geolocList);

          Navigator.pop(context);
        },
        child: const Text('はい'));

    final AlertDialog alert = AlertDialog(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      content: Text('${widget.date.yyyymmdd}のisarデータを消去しますか？'),
      actions: <Widget>[cancelButton, continueButton],
    );

    // ignore: inference_failure_on_function_invocation
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  ///
  Future<void> _deleteGeolocList({List<Geoloc>? geolocList}) async {
    setState(() => isLoading = true);

    // 削除完了を待つ
    // ignore: always_specify_types
    await GeolocRepository().deleteGeolocList(geolocList: geolocList).then((value) {
      if (mounted) {
        // ignore: always_specify_types
        Future.delayed(
          const Duration(seconds: 2),
          () {
            setState(() => isLoading = false);

            // 削除完了後にすぐ画面遷移
            // ignore: use_build_context_synchronously
            Navigator.pop(context);

            Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              // ignore: inference_failure_on_instance_creation, always_specify_types
              MaterialPageRoute(builder: (BuildContext context) => HomeScreen(baseYm: widget.date.yyyymm)),
            );
          },
        );
      }
    });
  }
}
