import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/app_configs.dart';

class CustomHttpClient {
  static final CustomHttpClient _singleton = CustomHttpClient._internal();
  factory CustomHttpClient() => _singleton;
  CustomHttpClient._internal();

  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    if (headers != null) {
      header.addAll(headers);
    }
    final response = await http.get(Uri.parse(url), headers: header);
    return _handleResponse(response);
  }

  Future<http.Response> post(String url, {Map<String, String>? headers, dynamic body, Encoding? encoding}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    if (headers != null) {
      header.addAll(headers);
    }

    final response = await http.post(Uri.parse(url), headers: header, body: body, encoding: encoding);
    return _handleResponse(response);
  }

  // Add other HTTP methods as needed (put, delete, etc.)

  Future<http.Response> _handleResponse(http.Response response) async {
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == false && jsonResponse['code'] == 'EXPIRED_JWT') {
        await refreshToken();
        // Optionally, you could retry the original request here. Be careful with recursion and ensure safe exit conditions.
        return await http.get(response.request!.url); // Example retry for GET request
      }
    }
    return response; // Return the original or retried response
  }

  Future<void> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');
    var apiUrl = AppConfigs().apiUrl; // Your API base URL
    var response = await http.post(Uri.parse('$apiUrl/sign-in/reissue'), body: {
      'refreshToken': refreshToken,
    });

    if (response.statusCode == 200) {
      var newToken = json.decode(response.body)['accessToken'];
      prefs.setString('accessToken', newToken);
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}
