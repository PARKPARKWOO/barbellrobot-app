import 'dart:convert';
import 'package:health/config/app_configs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomHttpClient {
  static final CustomHttpClient _singleton = CustomHttpClient._internal();

  factory CustomHttpClient() => _singleton;

  CustomHttpClient._internal();

  Future<dynamic> get<T>(
      String url, {
        Map<String, String>? headers,
        required T Function(dynamic) create,
      }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');

    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };
    if (headers != null) {
      header.addAll(headers);
    }

    final response = await http.get(Uri.parse(url), headers: header);
    return _handleResponse(response, create, requestType: 'GET', url: url, headers: header);
  }

  Future<dynamic> post<T>(
      String url, {
        Map<String, String>? headers,
        dynamic body,
        Encoding? encoding,
        required T Function(dynamic) create,
      }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');

    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };
    if (headers != null) {
      header.addAll(headers);
    }

    final response = await http.post(
      Uri.parse(url),
      headers: header,
      body: jsonEncode(body),
      encoding: encoding ?? Encoding.getByName('utf-8'),
    );
    return _handleResponse(response, create, requestType: 'POST', url: url, headers: header, body: body, encoding: encoding);
  }

  Future<dynamic> _handleResponse<T>(
      http.Response response,
      T Function(dynamic) create, {
        required String requestType,
        required String url,
        Map<String, String>? headers,
        dynamic body,
        Encoding? encoding,
      }) async {
    final responseBody = utf8.decode(response.bodyBytes);
    final dynamic responseJson = jsonDecode(responseBody);

    if (response.statusCode == 200) {
      if (responseJson['success'] == false && responseJson['code'] == 'EXPIRED_JWT') {
        await refreshToken();

        if (requestType == 'GET') {
          return get<T>(url, headers: headers, create: create);
        } else if (requestType == 'POST') {
          return post<T>(url, headers: headers, body: body, encoding: encoding, create: create);
        }
      }

      if (responseJson['success'] == false) {
        return ErrorResponse.fromJson(responseJson);
      }

      return ApiResponse<T>.fromJson(responseJson, create);
    } else {
      return ErrorResponse(
        success: false,
        message: 'Unexpected error',
        code: response.statusCode.toString(),
      );
    }
  }

  Future<void> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');
    var apiUrl = AppConfigs().apiUrl; // Your API base URL
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var data = {'refreshToken': refreshToken};
    var response = await http.post(
      Uri.parse('$apiUrl/sign-in/reissue'),
      headers: header,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      var newToken = jsonDecode(utf8.decode(response.bodyBytes))['data']['accessToken'];
      var newRefreshToken = jsonDecode(utf8.decode(response.bodyBytes))['data']['refreshToken'];
      prefs.setString('accessToken', newToken);
      prefs.setString('refreshToken', newRefreshToken);
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}

// Common response
class ApiResponse<T> {
  bool success;
  T data;

  ApiResponse({required this.success, required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) create) {
    return ApiResponse(
      success: json['success'],
      data: create(json['data']),
    );
  }

  Map<String, dynamic> toJson(T Function(T) create) {
    return {
      'success': success,
      'data': create(data),
    };
  }
}

class ErrorResponse {
  bool success;
  String message;
  String code;

  ErrorResponse({required this.success, required this.message, required this.code});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      success: json['success'],
      message: json['message'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
    };
  }
}
