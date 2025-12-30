

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/legacy.dart';

class LiveTrackingNotifier extends StateNotifier<bool>
{
  LiveTrackingNotifier():super(false);

  final service = FlutterBackgroundService();

  Future<void> startTracking() async
  {
    if(state) return;

    await service.startService();

    state = true;
  }


  Future<void> stopTracking() async
  {
    if(!state) return;

    service.invoke("stopService");

    state = false;
  }
}


final liveTrackingProvider = StateNotifierProvider<LiveTrackingNotifier, bool>((ref) {
  return LiveTrackingNotifier();
});