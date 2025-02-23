import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/geoloc_model.dart';
import '../../models/temple_latlng_model.dart';
import '../../models/temple_photo_model.dart';
import 'geoloc_map_control_panel_mixin.dart';

///
class GeolocMapControlPanelWidget extends ConsumerStatefulWidget {
  const GeolocMapControlPanelWidget({
    super.key,
    required this.geolocStateList,
    required this.mapController,
    required this.currentZoomEightTeen,
    required this.selectedHourMap,
    this.templeInfoList,
    required this.minMaxLatLngMap,
    this.displayTempMap,
    required this.date,
    required this.templePhotoDateList,
  });

  final DateTime date;
  final List<GeolocModel> geolocStateList;
  final MapController mapController;
  final double currentZoomEightTeen;
  final Map<String, List<String>> selectedHourMap;
  final List<TempleInfoModel>? templeInfoList;
  final Map<String, double> minMaxLatLngMap;
  final bool? displayTempMap;
  final List<TemplePhotoModel> templePhotoDateList;

  @override
  ConsumerState<GeolocMapControlPanelWidget> createState() => _GeolocMapControlPanelWidgetState();
}

///
class _GeolocMapControlPanelWidgetState extends ConsumerState<GeolocMapControlPanelWidget>
    with ControllersMixin<GeolocMapControlPanelWidget>, GeolocMapControlPanelAlertMixin {
  @override
  Widget build(BuildContext context) {
    return buildContent(context);
  }
}
