import 'dart:convert';
import 'package:nexus_frontend/models/userModel.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const baseUrl = "http://127.0.0.1:3000/api/auth/";

  Future<UserModel?> registerUser(UserModel user) async {
    final url = Uri.parse("${baseUrl}register");

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (res.statusCode == 201) {
        final data = jsonDecode(res.body);
        return UserModel.fromJson(data["user"]);
      } else {
        print("Register error: ${res.body}");
        return null;
      }
    } catch (err) {
      print("Register exception: $err");
      return null;
    }
  }

  Future<UserModel?> loginUser(String email, String password) async {
    final url = Uri.parse("${baseUrl}login");

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return UserModel.fromJson(data["user"]);
      } else {
        print("Login error: ${res.body}");
        return null;
      }
    } catch (err) {
      print("Login exception: $err");
      return null;
    }
  }
}
