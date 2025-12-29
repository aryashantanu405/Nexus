import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_frontend/models/userModel.dart';
import 'package:nexus_frontend/services/dioProvider.dart';
import 'package:nexus_frontend/services/tokenStorage.dart';

class AuthRepository {
  final Dio dio;
  final TokenStorage tokenStorage;

  AuthRepository(this.dio, this.tokenStorage);

  Future<bool> loginUser(String email, String password) async {
    try {
      final response = await dio.post(
        "/auth/login",
        data: {"email": email, "password": password},
      );

      if(response.statusCode != 200)
        {
          print(response.data);
          return false;
        }



      final data = response.data;

      await tokenStorage.saveAccessToken(data["tokens"]["accessToken"]);
      await tokenStorage.saveRefreshToken(data["tokens"]["refreshToken"]);

      return true;

    } on DioException catch (e) {
      print(e.response?.data ?? e.message);
      return false;
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
  
  Future<UserModel?> updateUser(UserModel updatedUser) async
  {

    try{
      final response = await dio.put("/users/profile/updateprofile", data: updatedUser.toJson());

      if(response.statusCode != 200)
        {
          return null;
        }

      final UserModel newUser = UserModel.fromJson(response.data["user"]);

      return newUser;
    }
        on DioException catch(err)
    {
      print(err.response);
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
