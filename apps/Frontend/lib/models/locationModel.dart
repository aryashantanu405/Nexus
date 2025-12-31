import 'package:latlong2/latlong.dart';

class LocationModel{
  final LatLng? position;
  final String? placeName;
  final String? locality;
  final String? administrativeArea;
  final String? country;


  LocationModel({this.position, this.administrativeArea, this.country, this.locality, this.placeName});


  factory LocationModel.fromJson(Map<String, dynamic> json)
  {
    return LocationModel();
  }
}