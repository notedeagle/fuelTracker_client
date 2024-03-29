import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_tracker_client/dto/expense_dto.dart';
import 'package:flutter_tracker_client/dto/refuel_dto.dart';
import 'package:flutter_tracker_client/dto/reports_dto.dart';
import 'package:flutter_tracker_client/dto/vehicle_dto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../bloc/auth_bloc/auth_event.dart';

String mainUrl = "http://localhost:8080";
final Dio _dio = Dio();
const FlutterSecureStorage storage = FlutterSecureStorage();

class UserRepository {
  var loginUrl = '$mainUrl/auth/login';
  var registerUrl = '$mainUrl/auth/register';

  Future<bool> hasToken() async {
    var value = await storage.read(key: 'token');
    if (value != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> persistToken(String token) async {
    var tokenType = "Bearer ";
    await storage.write(key: 'token', value: tokenType + token);
  }

  Future<void> deleteToken() async {
    storage.delete(key: 'token');
    storage.deleteAll();
  }

  Future<String> login(String login, String password) async {
    Response response = await _dio.post(loginUrl, data: {
      "username": login,
      "password": password,
    });

    return response.data['access_token'];
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
  var refuelUri = '$mainUrl/refuel';

  Future<List<RefuelDto>> getRefuelByCarName(String carName) async {
    var token = await storage.read(key: 'token');

    final response = await http.get(Uri.parse('$refuelUri/$carName'),
        headers: {HttpHeaders.authorizationHeader: "$token"});

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => RefuelDto.fromJson(data)).toList();
    } else if (response.statusCode == 204) {
      return List.empty();
    } else {
      throw Exception("Error occured");
    }
  }

  Future<http.Response> addRefuel(
      DateTime date,
      String carName,
      String fuel,
      bool fullTank,
      double litres,
      int odometer,
      double price,
      double totalCost,
      double latidute,
      double longitude) async {
    var token = await storage.read(key: 'token');

    final response = await http.post(Uri.parse('$refuelUri/$carName'),
        body: jsonEncode({
          "date": DateFormat('yyyy-MM-ddTHH:mm:ss').format(date),
          "fuel": fuel,
          "fullTank": fullTank,
          "litres": litres,
          "odometer": odometer,
          "price": price,
          "totalCost": totalCost,
          "latitude": latidute,
          "longitude": longitude
        }),
        headers: {
          HttpHeaders.authorizationHeader: "$token",
          "content-type": "application/json"
        });

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Error.");
    }
  }

  Future<http.Response> addElectricRefuel(
      DateTime date,
      String carName,
      bool fullTank,
      double startLvl,
      double endLvl,
      int odometer,
      double price) async {
    var token = await storage.read(key: 'token');

    final response = await http.post(Uri.parse('$refuelUri/electric/$carName'),
        body: jsonEncode({
          "date": DateFormat('yyyy-MM-ddTHH:mm:ss').format(date),
          "fullTank": fullTank,
          "startLvl": startLvl,
          "endLvl": endLvl,
          "odometer": odometer,
          "price": price,
        }),
        headers: {
          HttpHeaders.authorizationHeader: "$token",
          "content-type": "application/json"
        });

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Error.");
    }
  }

  void removeRefuel(int id) async {
    var token = await storage.read(key: 'token');

    await http.delete(Uri.parse('$refuelUri/$id'),
        headers: {HttpHeaders.authorizationHeader: "$token"});
  }
}

class VehicleRepository {
  var customerVehicles = '$mainUrl/vehicle';

  var userRepository = UserRepository();

  Future<List<VehicleDto>> getCustomerVehicles() async {
    var token = await storage.read(key: 'token');

    final response = await http.get(Uri.parse('$customerVehicles/user'),
        headers: {HttpHeaders.authorizationHeader: "$token"});

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => VehicleDto.fromJson(data)).toList();
    } else if (response.statusCode == 204) {
      return List.empty();
    } else {
      userRepository.deleteToken();
      LoggedOut;
      throw Exception("Error.");
    }
  }

  Future<http.Response> addVehicle(
      String brand,
      String model,
      String name,
      String plateNumber,
      String vehicleType,
      String yearOfProduction,
      double capacity) async {
    var token = await storage.read(key: 'token');

    final response = await http.post(Uri.parse(customerVehicles),
        body: jsonEncode({
          "brand": brand,
          "model": model,
          "name": name,
          "plateNumber": plateNumber,
          "vehicleType": vehicleType,
          "yearOfProduction": yearOfProduction,
          "capacity": capacity
        }),
        headers: {
          HttpHeaders.authorizationHeader: "$token",
          "content-type": "application/json"
        });

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 409) {
      throw Exception("Vehicle name taken.");
    } else {
      throw Exception("Error.");
    }
  }

  void removeVehicle(String name) async {
    var token = await storage.read(key: 'token');

    await http.delete(Uri.parse('$customerVehicles/$name'),
        headers: {HttpHeaders.authorizationHeader: "$token"});
  }
}

class ExpenseRepository {
  var expenseUri = '$mainUrl/expense';

  Future<List<ExpenseDto>> getExpenseByCarName(String carName) async {
    var token = await storage.read(key: 'token');

    final response = await http.get(Uri.parse('$expenseUri/$carName'),
        headers: {HttpHeaders.authorizationHeader: "$token"});

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => ExpenseDto.fromJson(data)).toList();
    } else if (response.statusCode == 204) {
      return List.empty();
    } else {
      throw Exception("Error occured");
    }
  }

  Future<http.Response> addExpense(String carName, DateTime date, int odometer,
      double totalCost, String note) async {
    var token = await storage.read(key: 'token');

    final response = await http.post(Uri.parse('$expenseUri/$carName'),
        body: jsonEncode({
          "date": DateFormat('yyyy-MM-ddTHH:mm:ss').format(date),
          "odometer": odometer,
          "totalCost": totalCost,
          "note": note
        }),
        headers: {
          HttpHeaders.authorizationHeader: "$token",
          "content-type": "application/json"
        });

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Error.");
    }
  }

  void removeExpense(int id) async {
    var token = await storage.read(key: 'token');

    await http.delete(Uri.parse('$expenseUri/$id'),
        headers: {HttpHeaders.authorizationHeader: "$token"});
  }
}

class ReportRepository {
  var reportUri = '$mainUrl/totalCost';

  Future<ReportsDto> getReportsByCarName(String carName) async {
    var token = await storage.read(key: 'token');

    final response = await http.get(Uri.parse('$reportUri/$carName'),
        headers: {HttpHeaders.authorizationHeader: "$token"});

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return ReportsDto.fromJson(jsonResponse);
    } else {
      throw Exception("Error occured");
    }
  }
}
