import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../pigeon/wifi_location.dart';

class DummyScreen extends StatefulWidget {
  const DummyScreen({super.key});

  @override
  State<DummyScreen> createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  bool _isRunning = false;
  bool _isLoading = false;
  List<WifiLocation> _locations = <WifiLocation>[];

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
  Future<void> _fetchData() async {
    final WifiLocationApi api = WifiLocationApi();
    final List<WifiLocation?> result = await api.getWifiLocations();
    setState(() {
      _locations = result.whereType<WifiLocation>().toList();

      _locations.sort((WifiLocation a, WifiLocation b) => '${a.date} ${a.time}'.compareTo('${b.date} ${b.time}') * -1);
    });
  }

  ///
  @override
  void initState() {
    super.initState();

    _checkStatus();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wi-Fi位置情報収集サービス')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(onPressed: _isLoading ? null : _startService, child: const Text('取得開始（Kotlin）')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _checkStatus, child: const Text('現在の稼働状態を確認')),
            const SizedBox(height: 12),
            Text(_isRunning ? '✅ サービス稼働中' : '❌ サービス停止中', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final WifiLocationApi api = WifiLocationApi();
                await api.deleteAllWifiLocations();

                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('全件削除しました')));
              },
              child: const Text('全削除'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _fetchData, child: const Text('Roomから取得（Flutter表示）')),
            const SizedBox(height: 12),
            Expanded(
              child: _locations.isEmpty
                  ? const Text('📭 データがまだありません')
                  : ListView.builder(
                      itemCount: _locations.length,
                      itemBuilder: (BuildContext context, int index) {
                        final WifiLocation loc = _locations[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text('📡 ${loc.ssid}'),
                            subtitle: Text('🕒 ${loc.date} ${loc.time}\n📍 緯度: ${loc.latitude}, 経度: ${loc.longitude}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
