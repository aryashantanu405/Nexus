class Distraction {
  final String package;
  final DateTime openedAt;
  final Duration duration;

  const Distraction({
    required this.package,
    required this.openedAt,
    required this.duration,
  });
}
