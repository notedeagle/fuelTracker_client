import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  static String mainUrl = "http://localhost:8081";
  var loginUrl = '$mainUrl/login';
  var registerUrl = '$mainUrl/register';

  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final Dio _dio = Dio();

  Future<bool> hasToken() async {
    var value = await storage.read(key: 'token');
    if (value != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> persistToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<void> deleteToken() async {
    storage.delete(key: 'token');
    storage.deleteAll();
  }

  Future<String> login(String username, String password) async {
    Response response = await _dio.post(loginUrl, data: {
      "username": username,
      "password": password,
    });
    return response.headers.value(HttpHeaders.authorizationHeader).toString();
  }

  Future<void> register(String email, String firstName, String lastName,
      String username, String password) async {
    await _dio.post(registerUrl, data: {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "username": username,
      "password": password
    });
  }
}
