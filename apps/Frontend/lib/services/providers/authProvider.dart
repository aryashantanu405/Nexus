
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexus_frontend/models/userModel.dart';
import 'package:nexus_frontend/services/api_services/authService.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});


final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier(ref.read(authServiceProvider));
});


class UserNotifier extends StateNotifier<UserModel?>{
  final AuthService authService;

  UserNotifier(this.authService):super(null);

  Future<void> registerUser(UserModel newUser) async
  {
    try{
      final user = await authService.registerUser(newUser);
      state = user;
    }
        catch(err)
    {
      state = null;
    }
  }
}