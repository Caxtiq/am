import 'user.dart';

class UserData {
  static final UserData _singleton = UserData._internal();

  factory UserData() {
    return _singleton;
  }

  UserData._internal();

  User? user;
  String token = "";

  void updateUser(User newUser, String newToken) {
    user = newUser;
    token = newToken;
  }
}