import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_tracker_client/dto/refuel_dto.dart';
import 'package:flutter_tracker_client/dto/vehicle_dto.dart';
import 'package:http/http.dart' as http;

String mainUrl = "http://localhost:8081";
final Dio _dio = Dio();
const FlutterSecureStorage storage = FlutterSecureStorage();

class UserRepository {
  var loginUrl = '$mainUrl/login';
  var registerUrl = '$mainUrl/register';

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

  Future<String> login(String email, String password) async {
    Response response = await _dio.post(loginUrl, data: {
      "email": email,
      "password": password,
    });
    return response.headers.value(HttpHeaders.authorizationHeader).toString();
  }

  Future<Response> register(String email, String firstName, String lastName,
      String username, String password) async {
    return await _dio.post(registerUrl,
        data: {
          "email": email,
          "firstName": firstName,
          "lastName": lastName,
          "username": username,
          "password": password
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
  }
}

class RefuelRepository {
  var refuelByCarName = '$mainUrl/refuel/';

  Future<List<RefuelDto>> getRefuelByCarName(String carName) async {
    var token = await storage.read(key: 'token');

    final response = await http.get(Uri.parse(refuelByCarName + carName),
        headers: {HttpHeaders.authorizationHeader: "$token"});

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => RefuelDto.fromJson(data)).toList();
    } else if (response.statusCode == 404) {
      return List.empty();
    } else {
      throw Exception("Error occured");
    }
  }
}

class VehicleRepository {
  var customerVehicles = '$mainUrl/vehicle/user';

  Future<List<VehicleDto>> getCustomerVehicles() async {
    var token = await storage.read(key: 'token');

    final response = await http.get(Uri.parse(customerVehicles),
        headers: {HttpHeaders.authorizationHeader: "$token"});

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => VehicleDto.fromJson(data)).toList();
    } else if (response.statusCode == 204) {
      return List.empty();
    } else {
      throw Exception("Error.");
    }
  }
}
