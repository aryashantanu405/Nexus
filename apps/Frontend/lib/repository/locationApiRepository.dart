

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';


class LocationApiRepository{
  final Dio dio;

  LocationApiRepository({Dio? dio})
      : dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://api.yourbackend.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<void> sendLocation(Position pos) async
  {
    print(pos.longitude);
    try{
      await dio.post("", data: {
        "latitude" : pos.latitude,
        "longitude" : pos.longitude
      });
    }
        on DioException catch(err)
    {
      debugPrint(err.response.toString());
    }
  }
}


final locationApiRepositoryProvider = Provider<LocationApiRepository>((ref) {
  return LocationApiRepository();
});