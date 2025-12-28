import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nexus_frontend/models/userModel.dart';
import 'package:nexus_frontend/repository/authRepository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading }

class AuthController extends StateNotifier<AuthStatus> {
  final AuthRepository authRepository;

  AuthController(this.authRepository) : super(AuthStatus.unknown) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    state = AuthStatus.loading;
    final loggedIn = await authRepository.isLoggedIn();

    state = loggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated;
  }

  Future<void> login(String email, String password) async {
    state = AuthStatus.loading;
     await authRepository.loginUser(email, password);
     state = AuthStatus.authenticated;


  }

  Future<void> registerUser(UserModel user) async{
    state = AuthStatus.loading;
    await authRepository.registerUser(user);
    state = AuthStatus.authenticated;
  }


  Future<void> logout() async {
    state = AuthStatus.loading;
    await authRepository.logout();
    state = AuthStatus.unauthenticated;
  }
}





final authControllerProvider =
    StateNotifierProvider<AuthController, AuthStatus>((ref) {
      return AuthController(ref.read(authRespositoryProvider));
    });
