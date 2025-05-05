// import 'dart:math';
//
//

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Utility {
  /// 背景取得
  // ignore: always_specify_types
  Widget getBackGround({context}) {
    return Image.asset('assets/images/bg.png',
        fit: BoxFit.fitHeight, color: Colors.black.withOpacity(0.7), colorBlendMode: BlendMode.darken);
  }

  ///
  void showError(String msg) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 5)));
  }

  ///
  Color getYoubiColor({
    required String date,
    required String youbiStr,
    required Map<String, String> holidayMap,
  }) {
    Color color = Colors.black.withOpacity(0.2);

    switch (youbiStr) {
      case 'Sunday':
        color = Colors.redAccent.withOpacity(0.2);

      case 'Saturday':
        color = Colors.blueAccent.withOpacity(0.2);

      default:
        color = Colors.black.withOpacity(0.2);
    }

    if (holidayMap[date] != null) {
      color = Colors.greenAccent.withOpacity(0.2);
    }

    return color;
  }

  ///
  double calculateDistance(LatLng p1, LatLng p2) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Meter, p1, p2);
  }

  ///
  List<Color> getTwelveColor() {
    return <Color>[
      const Color(0xffdb2f20),
      const Color(0xffefa43a),
      const Color(0xfffdf551),
      const Color(0xffa6c63d),
      const Color(0xff439638),
      const Color(0xff469c9e),
      const Color(0xff48a0e1),
      const Color(0xff3070b1),
      const Color(0xff020c75),
      const Color(0xff931c7a),
      const Color(0xffdc2f81),
      const Color(0xffdb2f5c),
    ];
  }
}

class NavigationService {
  const NavigationService._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
