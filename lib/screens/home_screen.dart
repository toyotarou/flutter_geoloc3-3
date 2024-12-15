import 'dart:async';
import 'dart:io';

import 'package:background_task/background_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../collections/geoloc.dart';
import '../extensions/extensions.dart';
import '../ripository/isar_repository.dart';
import 'components/dummy_geoloc_alert.dart';
import 'parts/geoloc_dialog.dart';

@pragma('vm:entry-point')
void backgroundHandler(Location data) {
  debugPrint('backgroundHandler: ${DateTime.now()}, $data');

  print('---------');
  print(data.lat);
  print(data.lng);
  print('---------');

  // ignore: always_specify_types
  Future(() async {
    await IsarRepository.configure();

    IsarRepository.isar.writeTxnSync(() {
      final DateTime now = DateTime.now();
      final DateFormat timeFormat = DateFormat('HH:mm:ss');
      final String currentTime = timeFormat.format(now);

      final Geoloc geoloc = Geoloc()
        ..date = DateTime.now().yyyymmdd
        ..time = currentTime
        ..latitude = data.lat.toString()
        ..longitude = data.lng.toString();

      IsarRepository.isar.geolocs.putSync(geoloc);
    });
  });
}

// ignore: unreachable_from_main
class HomeScreen extends StatefulWidget {
  // ignore: unreachable_from_main
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String bgText = 'no start';
  String statusText = 'status';
  bool isEnabledEvenIfKilled = true;

  late final StreamSubscription<Location> _bgDisposer;
  late final StreamSubscription<StatusEvent> _statusDisposer;

  ///
  @override
  void initState() {
    super.initState();

    _bgDisposer = BackgroundTask.instance.stream.listen((Location event) {
      final String message = '${DateTime.now()}: ${event.lat}, ${event.lng}';

      debugPrint(message);

      setState(() => bgText = message);
    });

    // ignore: always_specify_types
    Future(() async {
      final PermissionStatus result = await Permission.notification.request();
      debugPrint('notification: $result');
      if (Platform.isAndroid) {
        if (result.isGranted) {
          await BackgroundTask.instance.setAndroidNotification(
            title: 'バックグラウンド処理',
            message: 'バックグラウンド処理を実行中',
          );
        }
      }
    });

    _statusDisposer = BackgroundTask.instance.status.listen((StatusEvent event) {
      final String message = 'status: ${event.status.value}, message: ${event.message}';

      setState(() => statusText = message);
    });
  }

  ///
  @override
  void dispose() {
    _bgDisposer.cancel();
    _statusDisposer.cancel();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('geoloc'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                GeolocDialog(
                  context: context,
                  widget: const DummyGeolocAlert(),
                );
              },
              icon: const Icon(Icons.ac_unit)),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(bgText, textAlign: TextAlign.center),
                Text(statusText, textAlign: TextAlign.center),
                Flexible(
                  child: FilledButton(
                    onPressed: () async {
                      final PermissionStatus status = await Permission.location.request();
                      final PermissionStatus statusAlways = await Permission.locationAlways.request();

                      if (status.isGranted && statusAlways.isGranted) {
                        await BackgroundTask.instance.start(isEnabledEvenIfKilled: isEnabledEvenIfKilled);
                        setState(() => bgText = 'start');
                      }
                    },
                    child: const Text('Start'),
                  ),
                ),
                Flexible(
                  child: FilledButton(
                    onPressed: () async {
                      await BackgroundTask.instance.stop();

                      setState(() => bgText = 'stop');
                    },
                    child: const Text('Stop'),
                  ),
                ),
                Flexible(
                  child: Builder(
                    builder: (BuildContext context) {
                      return FilledButton(
                        onPressed: () async {
                          final bool isRunning = await BackgroundTask.instance.isRunning;
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('isRunning: $isRunning'),
                                action: SnackBarAction(
                                  label: 'close',
                                  onPressed: () => ScaffoldMessenger.of(context).clearSnackBars(),
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('isRunning'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
