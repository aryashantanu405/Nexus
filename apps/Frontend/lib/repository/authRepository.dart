import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_frontend/models/userModel.dart';
import 'package:nexus_frontend/services/dioProvider.dart';
import 'package:nexus_frontend/services/tokenStorage.dart';

class AuthRepository {
  final Dio dio;
  final TokenStorage tokenStorage;

  AuthRepository(this.dio, this.tokenStorage);

  Future<void> loginUser(String email, String password) async {
    try {
      final response = await dio.post(
        "/auth/login",
        data: {"email": email, "password": password},
      );

      final data = response.data;

      await tokenStorage.saveAccessToken(data["tokens"]["accessToken"]);
      await tokenStorage.saveRefreshToken(data["tokens"]["refreshToken"]);

    } on DioException catch (e) {
      print(e.response?.data ?? e.message);

    }
  }

  Future<void> registerUser(UserModel user) async {
    try {
      final response = await dio.post("/auth/register", data: user.toJson());

      await tokenStorage.saveAccessToken(response.data["tokens"]["accessToken"]);
      await tokenStorage.saveRefreshToken(response.data["tokens"]["refreshToken"]);


    } on DioException catch (e) {
      print(e.response?.data ?? e.message);

    }
  }

  Future<UserModel?> getCurrentUser() async
  {
    try{
      final response = await dio.get("/auth/profile");


      UserModel myUser = UserModel.fromJson(response.data["user"]);
      return myUser;
    }
    on DioException catch(err)
    {
      print("Error aaya  -> $err");
      return null;
    }
  }

  Future<void> logout() async {
    await tokenStorage.clear();
  }

  Future<bool> isLoggedIn() async {
    return await tokenStorage.getAccessToken() != null;
  }
}

final authRespositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(dioProvider), ref.read(tokenStorageProvider));
});
