import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../config/api_config.dart';

class AuthService extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  final http.Client _client = http.Client();
  String? _token;
  String? _role;
  String? _userId;
  DateTime? _tokenExpiry;

  AuthService() : super(); // Call the parent constructor

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  String? get token => _token;
  String? get role => _role;
  String? get userId => _userId;
  bool get isAuthenticated {
    return _token != null &&
        _tokenExpiry != null &&
        _tokenExpiry!.isAfter(DateTime.now());
  }

  // Initialize the service
  Future<void> init() async {
    try {
      _token = await storage.read(key: ApiConstants.authTokenKey);
      _role = await storage.read(key: ApiConstants.userRoleKey);
      _userId = await storage.read(key: ApiConstants.userIdKey);
      final expiryStr = await storage.read(key: 'token_expiry');
      if (expiryStr != null) {
        _tokenExpiry = DateTime.parse(expiryStr);
      }
      notifyListeners();
    } catch (e) {
      print('Error initializing auth: $e');
    }
  }

  // Login method with improved error handling
  Future<Map<String, dynamic>> login(
      String email, String password, String role) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.login}');
      print('Attempting login to: $uri'); // Debug log

      // Add mode: 'no-cors' for web requests
      final headers = {
        ...ApiConfig.defaultHeaders,
        if (kIsWeb) 'mode': 'no-cors',
      };

      final response = await _client
          .post(
            uri,
            headers: headers,
            body: jsonEncode({
              'email': email,
              'password': password,
              'role': role,
            }),
          )
          .timeout(ApiConfig.connectionTimeout);

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await _handleAuthResponse(responseData);
        return {
          'success': true,
          'message': 'Login successful',
          'data': responseData
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed',
          'error': responseData
        };
      }
    } on http.ClientException catch (e) {
      print('Network error: $e'); // Debug log
      return {
        'success': false,
        'message': 'Network error: ${e.message}',
        'error': e.toString()
      };
    } catch (e) {
      print('Unexpected error: $e'); // Debug log
      return {
        'success': false,
        'message': 'An unexpected error occurred',
        'error': e.toString()
      };
    }
  }

  // Register method
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.register}');
      print('Attempting registration to: $uri'); // Debug log

      // Add mode: 'no-cors' for web requests
      final headers = {
        ...ApiConfig.defaultHeaders,
        if (kIsWeb) 'mode': 'no-cors',
      };

      final response = await _client.post(
        uri,
        headers: headers,
        body: jsonEncode(userData),
      );

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await _handleAuthResponse(data);
        return {
          'success': true,
          'message': 'Registration successful',
          'data': data
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Registration failed',
          'error': error
        };
      }
    } catch (e) {
      print('Registration error: $e'); // Debug log
      return {
        'success': false,
        'message': 'Network error occurred',
        'error': e.toString()
      };
    }
  }

  // Refresh token
  Future<bool> refreshToken() async {
    if (_token == null) return false;

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.refreshToken}');
      final headers = {
        ...ApiConfig.defaultHeaders,
        'Authorization': 'Bearer $_token',
        if (kIsWeb) 'mode': 'no-cors',
      };

      final response = await _client.post(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _handleAuthResponse(data);
        return true;
      }
      return false;
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
  }

  // Handle auth response
  Future<void> _handleAuthResponse(Map<String, dynamic> data) async {
    await setToken(data['token']);
    await setRole(data['role']);
    await setUserId(data['userId'].toString());
    if (data['expiresIn'] != null) {
      _tokenExpiry = DateTime.now().add(Duration(seconds: data['expiresIn']));
      await storage.write(
          key: 'token_expiry', value: _tokenExpiry!.toIso8601String());
    }
  }

  // Set token and role
  Future<void> setToken(String token) async {
    await storage.write(key: ApiConstants.authTokenKey, value: token);
    _token = token;
    notifyListeners();
  }

  Future<void> setRole(String role) async {
    await storage.write(key: ApiConstants.userRoleKey, value: role);
    _role = role;
    notifyListeners();
  }

  Future<void> setUserId(String userId) async {
    await storage.write(key: ApiConstants.userIdKey, value: userId);
    _userId = userId;
    notifyListeners();
  }

  // Clear token and role (logout)
  Future<void> logout() async {
    await storage.deleteAll();
    _token = null;
    _role = null;
    _userId = null;
    _tokenExpiry = null;
    notifyListeners();
  }

  // Get auth headers
  Future<Map<String, String>> getAuthHeaders() async {
    if (!isAuthenticated) {
      throw Exception('Not authenticated');
    }
    return {
      ...ApiConfig.defaultHeaders,
      'Authorization': 'Bearer $_token',
      if (kIsWeb) 'mode': 'no-cors',
    };
  }
}
