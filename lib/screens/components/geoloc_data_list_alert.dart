import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../collections/geoloc.dart';
import '../../extensions/extensions.dart';
import '../../ripository/geolocs_repository.dart';
import '../home_screen.dart';

class GeolocDataListAlert extends ConsumerStatefulWidget {
  const GeolocDataListAlert({super.key, this.geolocList});

  final List<Geoloc>? geolocList;

  @override
  ConsumerState<GeolocDataListAlert> createState() => _GeolocDataListAlertState();
}

class _GeolocDataListAlertState extends ConsumerState<GeolocDataListAlert> {
  bool isLoading = false;

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Container(width: context.screenSize.width),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Geoloc Data List'),
                  SizedBox.shrink(),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.5), thickness: 5),
              Expanded(child: displayGeolocDataList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayGeolocDataList() {
    List<Widget> list = [];

    widget.geolocList
      ?..sort((a, b) => a.id.compareTo(b.id))
      ..forEach(
        (element) {
          list.add(
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 60, child: Text(element.id.toString())),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(element.date),
                      Text(element.time),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(element.latitude),
                      Text(element.longitude),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _showDeleteDialog(id: element.id),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
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
  void _showDeleteDialog({required int id}) {
    final Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
        onPressed: () {
          _deleteGeoloc(id: id);

          Navigator.pop(context);
        },
        child: const Text('はい'));

    final AlertDialog alert = AlertDialog(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      content: Text('isarデータ:$id を消去しますか？'),
      actions: <Widget>[cancelButton, continueButton],
    );

    // ignore: inference_failure_on_function_invocation
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  ///
  Future<void> _deleteGeoloc({required int id}) async {
    setState(() => isLoading = true);

    // 削除完了を待つ
    await GeolocRepository().deleteGeoloc(id: id);

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
  }
}
