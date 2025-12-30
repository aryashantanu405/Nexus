import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers/focus/focusController.dart';
import '../../controllers/focus/distraction_controller.dart';
import '../../models/focusModel.dart';
import '../../platform/digital_wellbeing_channel.dart';
import 'package:nexus_frontend/widgets/sliverAppBar.dart';

class FocusView extends ConsumerWidget {
  const FocusView({super.key});

  static final TextEditingController _subjectController =
      TextEditingController(text: "");

  static final TextEditingController _minuteController =
      TextEditingController(text: "25");

  /// ✅ FIXED FORMAT (TOTAL MINUTES, NOT MOD 60)
  String _format(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  /// ✅ PACKAGE → HUMAN READABLE NAME
  String _appName(String pkg) {
    final p = pkg.toLowerCase();

    if (p.contains("whatsapp")) return "WhatsApp";
    if (p.contains("youtube")) return "YouTube";
    if (p.contains("instagram")) return "Instagram";
    if (p.contains("chrome")) return "Chrome";
    if (p.contains("camera")) return "Camera";
    if (p.contains("gmail")) return "Gmail";
    if (p.contains("maps")) return "Google Maps";
    if (p.contains("settings")) return "Settings";

    // fallback
    final last = p.split('.').last;
    return last.isNotEmpty
        ? last[0].toUpperCase() + last.substring(1)
        : pkg;
  }

  Future<bool> _requestPermission(BuildContext context) async {
    final ok = await DigitalWellbeingChannel.hasPermission();
    if (ok) return true;

    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Permission Required"),
        content:
            const Text("Enable Usage Access to track distractions."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );

    if (res == true) {
      await DigitalWellbeingChannel.openSettings();
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focus = ref.watch(focusControllerProvider);
    final controller = ref.read(focusControllerProvider.notifier);
    final distractions = ref.watch(distractionProvider);

    // keep subject synced
    if (_subjectController.text != focus.subject) {
      _subjectController.text = focus.subject;
    }

    // keep minutes synced
    final selectedMin = focus.selectedDuration.inMinutes.toString();
    if (_minuteController.text != selectedMin && !focus.isRunning) {
      _minuteController.text = selectedMin;
    }

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: CustomScrollView(
        slivers: [
          myAppBar(
            "Focus Mode",
            "Deep Work & Productivity",
            "assets/images/loginIcon.png",
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  _focusCard(context, focus, controller),
                  SizedBox(height: 16.r),

                  /// 📊 TODAY STATS
                  _stats(focus),

                  /// 📱 DISTRACTIONS (FIXED NAMES)
                  if (distractions.isNotEmpty)
                    Card(
                      margin: EdgeInsets.only(top: 16.r),
                      child: ListView(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        children: distractions
                            .map(
                              (d) => ListTile(
                                leading:
                                    const Icon(Icons.apps),
                                title: Text(_appName(d.package)), // ✅ FIX
                                subtitle: Text(
                                  d.duration.inMinutes > 0
                                  ? "${d.duration.inMinutes} min used"
                                : "Opened during focus",

                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _focusCard(
    BuildContext context,
    FocusModel focus,
    FocusController c,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xff667eea), Color(0xff764ba2)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Working on",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          TextFormField(
            controller: _subjectController,
            enabled: !focus.isRunning,
            style: const TextStyle(color: Colors.white),
            decoration:
                const InputDecoration(border: InputBorder.none),
            onChanged: c.setSubject,
          ),

          const SizedBox(height: 12),

          /// 🔢 CUSTOM MINUTES (1–99)
          if (!focus.isRunning)
            Row(
              children: [
                const Icon(Icons.timer, color: Colors.white),
                const SizedBox(width: 8),
                SizedBox(
                  width: 70,
                  child: TextFormField(
                    controller: _minuteController,
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18),
                    decoration: const InputDecoration(
                      counterText: "",
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white),
                      ),
                    ),
                    onChanged: (v) {
                      final m = int.tryParse(v);
                      if (m == null || m < 1 || m > 99) return;
                      c.setDuration(Duration(minutes: m));
                    },
                  ),
                ),
                const SizedBox(width: 6),
                const Text("min",
                    style:
                        TextStyle(color: Colors.white70)),
              ],
            ),

          const SizedBox(height: 20),

          /// TIMER
          Center(
            child: Text(
              _format(focus.remaining),
              style: TextStyle(
                fontSize: 44.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// CONTROLS
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
            children: [
              if (!focus.isRunning)
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Start"),
                  onPressed: () async {
                    if (await _requestPermission(context)) {
                      c.start();
                    }
                  },
                ),
              if (focus.isRunning && !focus.isPaused)
                ElevatedButton.icon(
                  icon: const Icon(Icons.pause),
                  label: const Text("Pause"),
                  onPressed: c.pause,
                ),
              if (focus.isPaused)
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Resume"),
                  onPressed: c.resume,
                ),
              if (focus.isRunning || focus.isPaused)
                ElevatedButton.icon(
                  icon: const Icon(Icons.stop),
                  label: const Text("Stop"),
                  onPressed: c.stop,
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// 📊 TODAY STATS
  Widget _stats(FocusModel f) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.bar_chart, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "Today's Focus Stats",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: [
                _stat("Sessions", f.sessionsCompleted),
                _stat("Focus Time", "${f.totalFocusMinutes}m"),
                _stat(
                    "Productivity",
                    "${f.productivity.toInt()}%"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, Object value) {
    return Column(
      children: [
        Text(
          "$value",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
