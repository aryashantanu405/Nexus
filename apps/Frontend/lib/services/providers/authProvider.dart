import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexus_frontend/models/userModel.dart';
import 'package:nexus_frontend/services/api_services/authService.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});


final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<UserModel?>>((ref) {
  return UserNotifier(ref.read(authServiceProvider));
});


class UserNotifier extends StateNotifier<AsyncValue<UserModel?>>{
  final AuthService authService;

  UserNotifier(this.authService):super(const AsyncValue.data(null));

  Future<void> registerUser(UserModel newUser) async
  {
    state = const AsyncValue.loading();
    try{
      final user = await authService.registerUser(newUser);
      state = AsyncValue.data(user);
    }
        catch(err, st)
    {
      state = AsyncValue.error(err.toString(), st);
    }
  }


 Future<void> loginUser(String email, String password) async {
  state = const AsyncValue.loading();
  try {
    final user = await authService.loginUser(email, password);
    state = AsyncValue.data(user);
  } on Object catch (err, st) {
    state = AsyncValue.error(err, st);
  }
}



}