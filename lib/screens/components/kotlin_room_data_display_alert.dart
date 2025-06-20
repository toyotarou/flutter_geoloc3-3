import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../collections/kotlin_room_data.dart';
import '../../extensions/extensions.dart';
import '../../pigeon/wifi_location.dart';
import '../../ripository/kotlin_room_data_repository.dart';
import '../parts/error_dialog.dart';

class KotlinRoomDataDisplayAlert extends StatefulWidget {
  const KotlinRoomDataDisplayAlert({super.key});

  @override
  State<KotlinRoomDataDisplayAlert> createState() => _KotlinRoomDataDisplayAlertState();
}

class _KotlinRoomDataDisplayAlertState extends State<KotlinRoomDataDisplayAlert> {
  bool _isRunning = false;
  bool _isLoading = false;
  List<WifiLocation> kotlinRoomData = <WifiLocation>[];

  List<KotlinRoomData> inputKotlinRoomDataList = <KotlinRoomData>[];

  List<KotlinRoomData>? kotlinRoomDataList = <KotlinRoomData>[];

  ///
  Future<void> _requestPermissions() async {
    final PermissionStatus locationStatus = await Permission.location.request();
    final PermissionStatus fgServiceStatus = await Permission.ignoreBatteryOptimizations.request();

    if (!locationStatus.isGranted) {
      throw Exception('位置情報の権限が拒否されました');
    }
    if (!fgServiceStatus.isGranted) {
      debugPrint('バッテリー最適化除外の許可が拒否されました（続行可能）');
    }
  }

  ///
  Future<void> _startService() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _requestPermissions();

      final WifiLocationApi api = WifiLocationApi();
      await api.startLocationCollection();

      // ignore: inference_failure_on_instance_creation, always_specify_types
      await Future.delayed(const Duration(seconds: 1));
      await _checkStatus();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ エラー: $e')));
    }

    setState(() {
      _isLoading = false;
    });
  }

  ///
  Future<void> _checkStatus() async {
    final WifiLocationApi api = WifiLocationApi();
    final bool result = await api.isCollecting();
    setState(() {
      _isRunning = result;
    });
  }

  ///
  Future<void> _fetchKotlinRoomData() async {
    final WifiLocationApi api = WifiLocationApi();
    final List<WifiLocation?> result = await api.getWifiLocations();
    setState(() {
      kotlinRoomData = result.whereType<WifiLocation>().toList();

      kotlinRoomData
          .sort((WifiLocation a, WifiLocation b) => '${a.date} ${a.time}'.compareTo('${b.date} ${b.time}') * -1);
    });
  }

  ///
  @override
  void initState() {
    super.initState();

    _checkStatus();

    _fetchKotlinRoomData();

    _makeKotlinRoomDataList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (kotlinRoomDataList != null) ...<Widget>[
                Text(kotlinRoomDataList!.length.toString()),
              ],
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text('Kotlin Room Data'), SizedBox.shrink()],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                      onPressed: _isLoading ? null : _startService,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                      child: const Text('取得開始')),
                  Row(
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: _checkStatus,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                          child: const Text('稼働状態')),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.star,
                        color: _isRunning ? Colors.yellow : Colors.white.withValues(alpha: 0.2),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                      onPressed: _fetchKotlinRoomData,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen.withOpacity(0.2)),
                      child: const Text('Roomから取得')),
                  ElevatedButton(
                      onPressed: () {
                        inputKotlinRoomData();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                      child: const Text('isar登録')),
                ],
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 2),
              Container(
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        // final WifiLocationApi api = WifiLocationApi();
                        // await api.deleteAllWifiLocations();
                        //
                        // // ignore: use_build_context_synchronously
                        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('全件削除しました')));
                        //
                        //
                        //
                        //
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.2)),
                      child: const Text('Room全削除'),
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.2)),
                        child: const Text('isar全削除')),
                  ],
                ),
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 2),
              const SizedBox(height: 10),
              Expanded(
                child: kotlinRoomData.isEmpty
                    ? const Text('📭 データがまだありません')
                    : ListView.builder(
                        itemCount: kotlinRoomData.length,
                        itemBuilder: (BuildContext context, int index) {
                          final WifiLocation loc = kotlinRoomData[index];

                          final String ssid = loc.ssid.replaceAll('"', '');

                          inputKotlinRoomDataList.add(KotlinRoomData()
                            ..date = loc.date
                            ..time = loc.time
                            ..ssid = ssid
                            ..latitude = loc.latitude
                            ..longitude = loc.longitude);

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            color: Colors.transparent,
                            child: ListTile(
                              title: Text(ssid),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('${loc.date} ${loc.time}'),
                                  Container(
                                      alignment: Alignment.topRight, child: Text('${loc.latitude} / ${loc.longitude}')),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _makeKotlinRoomDataList() async {
    KotlinRoomDataRepository().getKotlinRoomDataList().then((List<KotlinRoomData>? value) {
      if (mounted) {
        setState(() {
          kotlinRoomDataList = value;
        });
      }
    });
  }

  ///
  Future<void> inputKotlinRoomData() async {
    if (inputKotlinRoomDataList.isEmpty) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () => error_dialog(
            // ignore: use_build_context_synchronously
            context: context,
            title: '登録できません。',
            content: '値を正しく入力してください。'),
      );

      return;
    }

    List<KotlinRoomData> inputData = <KotlinRoomData>[];

    if (kotlinRoomDataList != null) {
      final List<KotlinRoomData>? list = kotlinRoomDataList;

      list!.sort((KotlinRoomData a, KotlinRoomData b) => '${a.date} ${a.time}'.compareTo('${b.date} ${b.time}') * -1);

      final DateTime maxDateTime = DateTime(
        list[0].date.split('-')[0].toInt(),
        list[0].date.split('-')[1].toInt(),
        list[0].date.split('-')[2].toInt(),
        list[0].time.split(':')[0].toInt(),
        list[0].time.split(':')[1].toInt(),
      );

      for (final KotlinRoomData element in inputKotlinRoomDataList) {
        if (DateTime(
          element.date.split('-')[0].toInt(),
          element.date.split('-')[1].toInt(),
          element.date.split('-')[2].toInt(),
          element.time.split(':')[0].toInt(),
          element.time.split(':')[1].toInt(),
        ).isAfter(maxDateTime)) {
          inputData.add(element);
        }
      }
    } else {
      inputData = inputKotlinRoomDataList;
    }

    // ignore: always_specify_types
    await KotlinRoomDataRepository().inputKotlinRoomDataList(kotlinRoomDataList: inputData).then((value) {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
}
