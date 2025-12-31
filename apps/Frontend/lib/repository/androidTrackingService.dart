import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';

import 'locationApiRepository.dart';
import 'locationRepository.dart';

@pragma('vm:entry-point')
void androidTrackingService(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "Live Tracking Enabled",
      content: "Your location is being updated",
    );
  }

  final locationRepo = LocationRepository();
  final apiRepo = LocationApiRepository(); // plain Dart

  DateTime? lastSent;

  locationRepo.positionStream().listen((position) async {
    if (!position.latitude.isFinite ||
        !position.longitude.isFinite) {
      return;
    }

    final now = DateTime.now();
    if (lastSent != null &&
        now.difference(lastSent!).inMinutes < 5) {
      return;
    }

    lastSent = now;

    await apiRepo.sendLocation(position);
  });
}
