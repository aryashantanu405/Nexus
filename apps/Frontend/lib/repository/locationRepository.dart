

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationRepository {
  Future<LatLng?> getCurrentLatLang() async {
    final permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    final pos = await Geolocator.getCurrentPosition();

    // 🚨 CRITICAL WEB FIX
    if (!pos.latitude.isFinite || !pos.longitude.isFinite) {
      debugPrint(
        'Invalid GPS values: lat=${pos.latitude}, lng=${pos.longitude}',
      );
      return null;
    }

    return LatLng(pos.latitude, pos.longitude);
  }

  Stream<Position> positionStream()
  {
    return Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 30));
  }

}



final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepository();
});