

import 'package:flutter_riverpod/legacy.dart';
import 'package:latlong2/latlong.dart';
import 'package:nexus_frontend/models/locationModel.dart';
import 'package:nexus_frontend/repository/locationRepository.dart';

class LocationController extends StateNotifier<LocationStatus>{

  LocationRepository locationRepository;
  LocationController(this.locationRepository):super(LocationStatus(currentPos: LatLng(0, 0), currentPlace: LocationModel(country: "Unknown", administrativeArea: "Unknown", locality: "Unknown", placeName: "Unknown")));


  Future<void> getCurrentLocation() async
  {
    final currLocation = await locationRepository.getCurrentLatLang();
    state = state.copyWith(currLocation, null);
    final placeName = await locationRepository.getPlaceName(state.currentPos);
    state = state.copyWith(null, placeName);
    print(placeName.placeName);
  }


}

class LocationStatus
{
  final LatLng currentPos;
  final LocationModel currentPlace;

  LocationStatus({required this.currentPos, required this.currentPlace});

  LocationStatus copyWith(LatLng? currentPos, LocationModel? currentPlace)
  {
    return LocationStatus(currentPos: currentPos ?? this.currentPos, currentPlace: currentPlace ?? this.currentPlace);
  }
}



final locationControllerProvider = StateNotifierProvider<LocationController, LocationStatus>((ref) {
  return LocationController(ref.read(locationRepositoryProvider));
});