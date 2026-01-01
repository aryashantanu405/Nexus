import 'package:latlong2/latlong.dart';

class LocationModel{
  final LatLng? position;
  final String? placeName;
  final String? locality;
  final String? administrativeArea;
  final String? country;
  final double? lat;
  final double? lng;


  LocationModel({this.position, this.administrativeArea, this.country, this.locality, this.placeName, this.lat, this.lng});

  Map<String,dynamic> toJson()
  {
    return {
      "position" : position?.toJson(),
      "placeName": placeName,
      "locality" : locality,
      "administrativeArea" : administrativeArea,
      "country" : country,
      "lat" : lat,
      "lng" : lng
    };
  }


  factory LocationModel.fromJson(Map<String, dynamic> json)
  {

    return LocationModel(
      lat: json["coordinates"][1],
      lng: json["coordinates"][0],
      position: LatLng(json["coordinates"][1], json["coordinates"][0]),
    );
  }
}