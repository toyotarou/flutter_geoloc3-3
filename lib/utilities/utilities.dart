import 'dart:math';

import 'package:flutter/material.dart';

class Utility {
  /// 背景取得
  // ignore: always_specify_types
  Widget getBackGround({context}) {
    return Image.asset(
      'assets/images/bg.png',
      fit: BoxFit.fitHeight,
      color: Colors.black.withOpacity(0.7),
      colorBlendMode: BlendMode.darken,
    );
  }

  ///
  void showError(String msg) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 5),
      ),
    );
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
        break;
    }

    if (holidayMap[date] != null) {
      color = Colors.greenAccent.withOpacity(0.2);
    }

    return color;
  }

  ///
  String calcDistance(
      {required double originLat, required double originLng, required double destLat, required double destLng}) {
    final double distanceKm = 6371 *
        acos(
          cos(originLat / 180 * pi) * cos((destLng - originLng) / 180 * pi) * cos(destLat / 180 * pi) +
              sin(originLat / 180 * pi) * sin(destLat / 180 * pi),
        );

    return distanceKm.toString();
  }

  ///
  String calculateDistance(
      {required double originLat, required double originLng, required double destLat, required double destLng}) {
    const int earthRadiusKm = 6371;

    double toRadians(double degree) => degree * pi / 180;

    final double dLat = toRadians(destLat - originLat);
    final double dLon = toRadians(destLng - originLng);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(toRadians(originLat)) * cos(toRadians(destLat)) * sin(dLon / 2) * sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final double distance = earthRadiusKm * c;

    return distance.toString();
  }
}

class NavigationService {
  const NavigationService._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
