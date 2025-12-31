

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:nexus_frontend/models/locationModel.dart';

class LocationRepository {
  Future<LatLng?> getCurrentLatLang() async {
    final permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    final pos = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.best));

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

  Future<LocationModel> getPlaceName(LatLng pos) async {
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse'
          '?lat=${pos.latitude}&lon=${pos.longitude}&format=json',
    );
    final response = await http.get(uri, headers: {
      'User-Agent': 'your-app-name'
    });

    final data = jsonDecode(response.body);

    final address = data['address'] ?? {};

    return LocationModel(
      position: pos,
      placeName: data['display_name'] ?? 'Unknown',
      country: address['country'],
      administrativeArea: address['state'],
      locality: address['city'] ?? address['town'] ?? address['village'],
    );
  }


}



final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepository();
});