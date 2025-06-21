import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../collections/geoloc.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../ripository/geolocs_repository.dart';
import '../home_screen.dart';

class GeolocDataListAlert extends ConsumerStatefulWidget {
  const GeolocDataListAlert({super.key, this.geolocList});

  final List<Geoloc>? geolocList;

  @override
  ConsumerState<GeolocDataListAlert> createState() => _GeolocDataListAlertState();
}

class _GeolocDataListAlertState extends ConsumerState<GeolocDataListAlert> with ControllersMixin<GeolocDataListAlert> {
  bool isLoading = false;

  ///
  @override
  Widget build(BuildContext context) {
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
                      const Text('Geoloc Data List'),
                      ElevatedButton(
                        onPressed: () => _showDeleteDialog(),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                        child: const Text('delete'),
                      ),
                    ],
                  ),
                  Divider(color: Colors.white.withOpacity(0.5), thickness: 5),
                  Expanded(child: displayGeolocDataList()),
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
  Widget displayGeolocDataList() {
    final List<Widget> list = <Widget>[];

    widget.geolocList
      ?..sort((Geoloc a, Geoloc b) => a.id.compareTo(b.id))
      ..forEach(
        (Geoloc element) {
          list.add(
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 60, child: Text(element.id.toString())),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(element.date),
                      Text(element.time),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(element.latitude),
                      Text(element.longitude),
                    ],
                  ),
                  Checkbox(
                    value: appParamState.selectedGeolocListForDelete.contains(element),
                    onChanged: (bool? value) => appParamNotifier.setSelectedGeolocListForDelete(geoloc: element),
                    activeColor: Colors.greenAccent.withValues(alpha: 0.2),
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                ],
              ),
            ),
          );
        },
      );

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) =>
                  DefaultTextStyle(style: const TextStyle(fontSize: 12), child: list[index]),
              childCount: list.length),
        ),
      ],
    );
  }

  ///
  void _showDeleteDialog() {
    final Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
        onPressed: () {
          _deleteGeolocList();

          Navigator.pop(context);
        },
        child: const Text('はい'));

    final AlertDialog alert = AlertDialog(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      content: const Text('isarデータを消去しますか？'),
      actions: <Widget>[cancelButton, continueButton],
    );

    // ignore: inference_failure_on_function_invocation
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  ///
  Future<void> _deleteGeolocList() async {
    setState(() => isLoading = true);

    if (appParamState.selectedGeolocListForDelete.isNotEmpty) {
      // ignore: always_specify_types
      GeolocRepository().deleteGeolocList(geolocList: appParamState.selectedGeolocListForDelete).then(
        // ignore: always_specify_types
        (value) {
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
                  MaterialPageRoute(builder: (BuildContext context) => HomeScreen(baseYm: DateTime.now().yyyymm)),
                );
              },
            );
          }
        },
      );
    }
  }
}
