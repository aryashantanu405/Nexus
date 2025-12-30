import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/focusModel.dart';
import '../../models/distraction_model.dart';
import '../../platform/digital_wellbeing_channel.dart';
import 'distraction_controller.dart';

class FocusController extends Notifier<FocusModel>
    with WidgetsBindingObserver {
  Timer? _timer;

  @override
  FocusModel build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _timer?.cancel();
    });

    return FocusModel(
      selectedDuration: const Duration(minutes: 25),
      remaining: const Duration(minutes: 25),
      isRunning: false,
      isPaused: false,
      sessionsCompleted: 0,
      totalFocusMinutes: 0,
      manualPauses: 0,
      productivity: 100,
      subject: "Deep Work",
    );
  }

  void setSubject(String value) {
    if (state.isRunning) return;
    state = state.copyWith(subject: value);
  }

  void setDuration(Duration duration) {
    if (state.isRunning) return;
    state = state.copyWith(
      selectedDuration: duration,
      remaining: duration,
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remaining.inSeconds <= 1) {
        stop();
      } else {
        state = state.copyWith(
          remaining:
              state.remaining - const Duration(seconds: 1),
        );
      }
    });
  }

  Future<void> start() async {
    final hasPermission =
        await DigitalWellbeingChannel.hasPermission();

    if (!hasPermission) {
      await DigitalWellbeingChannel.openSettings();
      return;
    }

    ref.read(distractionProvider.notifier).clear();

    state = state.copyWith(
      isRunning: true,
      isPaused: false,
      remaining: state.selectedDuration,
      manualPauses: 0,
      subject: state.subject.trim().isEmpty
          ? "Deep Work"
          : state.subject.trim(),
    );

    _startTimer();
  }

  void pause() {
    if (!state.isRunning || state.isPaused) return;
    _timer?.cancel();
    state = state.copyWith(
      isPaused: true,
      manualPauses: state.manualPauses + 1,
    );
  }

  void resume() {
    if (!state.isPaused) return;
    state = state.copyWith(isPaused: false);
    _startTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.paused &&
        state.isRunning &&
        !state.isPaused) {
      _timer?.cancel();
    }

    if (s == AppLifecycleState.resumed &&
        state.isRunning &&
        !state.isPaused) {
      _startTimer();
    }
  }

  Future<void> stop() async {
    _timer?.cancel();

    final now = DateTime.now();
    final startTime = now.subtract(state.selectedDuration);

    final usage =
        await DigitalWellbeingChannel.getUsage(startTime, now);

    final distractionCtrl =
        ref.read(distractionProvider.notifier);

    final Map<String, List<DateTime>> grouped = {};

    for (final u in usage) {
      final pkg = u['package'] as String;
      final time =
          DateTime.fromMillisecondsSinceEpoch(u['time']);
      if (pkg.contains("launcher")) continue;

      grouped.putIfAbsent(pkg, () => []);
      grouped[pkg]!.add(time);
    }

    grouped.forEach((pkg, times) {
      times.sort();
      final openedAt = times.first;
      Duration total = Duration.zero;

      for (int i = 0; i < times.length - 1; i++) {
        final diff = times[i + 1].difference(times[i]);
        if (diff.inSeconds > 3 && diff.inMinutes < 60) {
          total += diff;
        }
      }

      distractionCtrl.add(
        Distraction(
          package: pkg,
          openedAt: openedAt,
          duration: total,
        ),
      );
    });

    final focusMinutes =
        state.selectedDuration.inMinutes -
        state.remaining.inMinutes;

    final completionRatio =
        focusMinutes / state.selectedDuration.inMinutes;

    final sessionProductivity =
        (completionRatio * 100 -
                state.manualPauses * 10)
            .clamp(0, 100);

    final totalSessions = state.sessionsCompleted + 1;

    final newAverage =
        ((state.sessionsCompleted * state.productivity) +
                sessionProductivity) /
            totalSessions;

    state = state.copyWith(
      isRunning: false,
      isPaused: false,
      sessionsCompleted: totalSessions,
      totalFocusMinutes:
          state.totalFocusMinutes + focusMinutes,
      productivity: newAverage,
      remaining: state.selectedDuration,
      subject: "Deep Work",
    );
  }
}

final focusControllerProvider =
    NotifierProvider<FocusController, FocusModel>(
  FocusController.new,
);
