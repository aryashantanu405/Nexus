import 'package:flutter/services.dart';

class DigitalWellbeingChannel {
  static const MethodChannel _channel =
      MethodChannel('digital_wellbeing');

  static Future<bool> hasPermission() async {
    return await _channel.invokeMethod('hasUsagePermission');
  }

  static Future<void> openSettings() async {
    await _channel.invokeMethod('openUsageSettings');
  }

  static Future<List<Map>> getUsage(
    DateTime start,
    DateTime end,
  ) async {
    final List data = await _channel.invokeMethod(
      'getAppUsage',
      {
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
      },
    );
    return data.cast<Map>();
  }
}
