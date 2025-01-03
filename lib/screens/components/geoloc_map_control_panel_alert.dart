import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/geoloc_model.dart';
import '../../models/temple_latlng_model.dart';

class GeolocMapControlPanelAlert extends ConsumerStatefulWidget {
  const GeolocMapControlPanelAlert({
    super.key,
    required this.geolocStateList,
    required this.mapController,
    required this.currentZoomEightTeen,
    required this.selectedHourMap,
    this.templeInfoList,
  });

  final List<GeolocModel> geolocStateList;
  final MapController mapController;
  final double currentZoomEightTeen;
  final Map<String, List<String>> selectedHourMap;
  final List<TempleInfoModel>? templeInfoList;

  @override
  ConsumerState<GeolocMapControlPanelAlert> createState() => _GeolocMapControlPanelAlertState();
}

class _GeolocMapControlPanelAlertState extends ConsumerState<GeolocMapControlPanelAlert> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
