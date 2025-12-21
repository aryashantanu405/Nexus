

class UserModel{
  final String username;
  final String email;
  final String name;
  final String? password;

  UserModel({required this.name, required this.email, required this.username, required this.password});


  Map<String, dynamic> toJson()
  {
    return {
      "username" : username,
      "email" : email,
      "name" : name,
      "password" : password
    };
  }


  factory UserModel.fromJson(Map<String, dynamic> json)
  {
    return UserModel(name: json["name"], email: json["email"], username: json["username"], password: json["password"]);
  }
}