

import 'package:flutter_riverpod/legacy.dart';
import 'package:latlong2/latlong.dart';
import 'package:nexus_frontend/repository/locationRepository.dart';

class LocationController extends StateNotifier<LocationStatus>{

  LocationRepository locationRepository;
  LocationController(this.locationRepository):super(LocationStatus(currentPos: LatLng(0, 0)));


  Future<void> getCurrentLocation() async
  {
    final currLocation = await locationRepository.getCurrentLatLang();
    state = state.copyWith(currLocation);
  }


}

class LocationStatus
{
  final LatLng currentPos;

  LocationStatus({required this.currentPos});

  LocationStatus copyWith(LatLng? currentPos)
  {
    return LocationStatus(currentPos: currentPos ?? this.currentPos);
  }
}



final locationControllerProvider = StateNotifierProvider<LocationController, LocationStatus>((ref) {
  return LocationController(ref.read(locationRepositoryProvider));
});