import 'package:library_app/models/user.dart';

class UserData {
  static final UserData _singleton = UserData._internal();
  factory UserData() => _singleton;
  UserData._internal();

  User? user;

  String token = "";

  void updateUser(User newUserData, String newToken) {
    user = newUserData;
    token = newToken;
  }
}
