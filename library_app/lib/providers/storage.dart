import 'package:library_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static final Storage _singleton = Storage._internal();
  factory Storage() => _singleton;
  Storage._internal();

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _token = _prefs.getString("token") ?? "";
  }

  void initUser(User user, String token) {
    _user = user;
    _token = token;
    _prefs.setString("token", token);
  }

  Future<void> deinitUser() async {
    _token = "";
    await _prefs.remove("token");
  }

  late User _user;
  User get user {
    if (isUserInitialized) return _user;
    throw Exception("User not initialized");
  }

  late String _token;
  String get token {
    if (isUserInitialized) return _token;
    throw Exception("User not initialized");
  }

  bool get isUserInitialized => _token.isNotEmpty;
}
