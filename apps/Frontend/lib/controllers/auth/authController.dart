
import 'package:flutter_riverpod/legacy.dart';

import 'package:nexus_frontend/models/userModel.dart';
import 'package:nexus_frontend/repository/authRepository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading, notRegistered }

class AuthController extends StateNotifier<UserState> {
  final AuthRepository authRepository;

  AuthController(this.authRepository) : super(UserState(authStatus: AuthStatus.unknown, currentUser: null)) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    state = state.copyWith(AuthStatus.loading, null);
    final loggedIn = await authRepository.isLoggedIn();

    if(loggedIn)
      {
        final UserModel? myUser = await authRepository.getCurrentUser();
        state = state.copyWith(AuthStatus.authenticated, myUser);

        return;
      }

    state = state.copyWith(AuthStatus.unauthenticated, null);
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(AuthStatus.loading, null);
     final loggedIn = await authRepository.loginUser(email, password);
     if(!loggedIn)
       {
         state = state.copyWith(AuthStatus.unauthenticated, null);
         return;
       }
     final UserModel? myUser = await authRepository.getCurrentUser();
     if(myUser == null)
       {
         state = state.copyWith(AuthStatus.unauthenticated, null);
         return;
       }
     state = state.copyWith(AuthStatus.authenticated, myUser);


  }

  Future<void> updateUser(UserModel updatedUser) async
  {
    state = state.copyWith(AuthStatus.loading, null);
    final UserModel? myUser = await authRepository.updateUser(updatedUser);
    state = state.copyWith(AuthStatus.authenticated, myUser);

  }

  Future<void> registerUser(UserModel user) async{
    state = state.copyWith(AuthStatus.loading, null);
    final registered = await authRepository.registerUser(user);
    if(!registered)
      {
        state = state.copyWith(AuthStatus.notRegistered, null);
        return;
      }
    final myUser = await authRepository.getCurrentUser();
    state = state.copyWith(AuthStatus.authenticated, myUser);
  }


  Future<void> logout() async {
    state = state.copyWith(AuthStatus.loading, null);
    await authRepository.logout();
    state = state.copyWith(AuthStatus.unauthenticated, null);
  }

  void goToRegisterScreen()
  {
    state = state.copyWith(AuthStatus.notRegistered, null);
  }

  void goToLoginScreen()
  {
    state = state.copyWith(AuthStatus.unauthenticated, null);
  }
}


class UserState{
  final AuthStatus authStatus;
  final UserModel? currentUser;

  UserState({required this.authStatus, required this.currentUser});

  UserState copyWith(AuthStatus? authStatus, UserModel? currentUser)
  {
    return UserState(authStatus: authStatus ?? this.authStatus, currentUser: currentUser ?? this.currentUser);
  }
}


final authControllerProvider =
    StateNotifierProvider<AuthController, UserState>((ref) {
      return AuthController(ref.read(authRespositoryProvider));
    });
