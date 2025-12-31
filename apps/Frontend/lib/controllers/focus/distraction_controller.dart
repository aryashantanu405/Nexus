import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/distraction_model.dart';

class DistractionController
    extends Notifier<List<Distraction>> {
  @override
  List<Distraction> build() => [];

  void add(Distraction d) {
    state = [...state, d];
  }

  void clear() {
    state = [];
  }
}

final distractionProvider =
    NotifierProvider<DistractionController, List<Distraction>>(
  DistractionController.new,
);
