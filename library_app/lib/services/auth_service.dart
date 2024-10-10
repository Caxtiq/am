import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:library_app/models/user_data.dart';

class AuthService {
  final String baseUrl = "http://localhost:8080/api/auth";

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
