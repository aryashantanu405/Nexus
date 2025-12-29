import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:nexus_frontend/models/userModel.dart';
import 'package:nexus_frontend/repository/aiRepository.dart';
import 'package:nexus_frontend/repository/authRepository.dart';

class UserController extends StateNotifier<UserState> {
  final AuthRepository authRepository;
  final AIRepository aiRepository;

  UserController(this.authRepository, this.aiRepository)
      : super(UserState(currentUser: null, aiInsight: ""));

  /// ✅ Load user safely
  Future<void> loadUser() async {
    try {
      final user = await authRepository.getCurrentUser();

      if (user == null) {
        debugPrint("loadUser: user is null");
        return;
      }

      state = state.copyWith(
        currentUser: user,
        aiInsight: state.aiInsight,
      );
    } catch (e, st) {
      debugPrint("loadUser error: $e");
      debugPrintStack(stackTrace: st);
    }
  }

  /// ✅ Load AI insight safely
  Future<void> loadAIInsight() async {
    try {
      final insight = await aiRepository.getAIInsight();

      if (insight == null || insight.isEmpty) return;

      state = state.copyWith(
        currentUser: state.currentUser,
        aiInsight: insight,
      );
    } catch (e) {
      debugPrint("loadAIInsight error: $e");
    }
  }



  /// ✅ Clear on logout
  void clear() {
    state = UserState(currentUser: null, aiInsight: "");
  }
}

/* ===============================
   STATE
================================ */

class UserState {
  final UserModel? currentUser;
  final String aiInsight;

  const UserState({
    required this.currentUser,
    required this.aiInsight,
  });

  UserState copyWith({
    UserModel? currentUser,
    String? aiInsight,
  }) {
    return UserState(
      currentUser: currentUser ?? this.currentUser,
      aiInsight: aiInsight ?? this.aiInsight,
    );
  }
}

/* ===============================
   PROVIDER
================================ */

final userControllerProvider =
    StateNotifierProvider<UserController, UserState>((ref) {
  return UserController(
    ref.read(authRespositoryProvider),
    ref.read(aiRepositoryProvider),
  );
});
