class FocusModel {
  final Duration selectedDuration;
  final Duration remaining;
  final bool isRunning;
  final bool isPaused;

  final int sessionsCompleted;
  final int totalFocusMinutes;
  final int manualPauses;

  final double productivity;
  final String subject;

  const FocusModel({
    required this.selectedDuration,
    required this.remaining,
    required this.isRunning,
    required this.isPaused,
    required this.sessionsCompleted,
    required this.totalFocusMinutes,
    required this.manualPauses,
    required this.productivity,
    required this.subject,
  });

  FocusModel copyWith({
    Duration? selectedDuration,
    Duration? remaining,
    bool? isRunning,
    bool? isPaused,
    int? sessionsCompleted,
    int? totalFocusMinutes,
    int? manualPauses,
    double? productivity,
    String? subject,
  }) {
    return FocusModel(
      selectedDuration: selectedDuration ?? this.selectedDuration,
      remaining: remaining ?? this.remaining,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
      totalFocusMinutes:
          totalFocusMinutes ?? this.totalFocusMinutes,
      manualPauses: manualPauses ?? this.manualPauses,
      productivity: productivity ?? this.productivity,
      subject: subject ?? this.subject,
    );
  }
}
