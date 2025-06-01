import 'dart:convert';
import 'dart:html' if (dart.library.html) 'dart:html' show window;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb, ChangeNotifier;
import 'config/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  String? _token;
  String? _role;
  int? _userId;

  String? get token => _token;
  String? get role => _role;
  int? get userId => _userId;

  static String get baseUrl => ApiConfig.baseUrl;
  static String get origin =>
      kIsWeb ? window.location.origin : 'app://celebrate';
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  static const String tokenKey = 'auth_token';

  // Initialize the service
  Future<void> init() async {
    try {
      _token = await _storage.read(key: 'auth_token');
      _role = await _storage.read(key: 'user_role');
      final userIdStr = await _storage.read(key: 'user_id');
      _userId = userIdStr != null ? int.parse(userIdStr) : null;
      notifyListeners();
    } catch (e) {
      print('Error initializing auth: $e');
    }
  }

  // Set token and role
  Future<void> setToken(String token) async {
    try {
      await _storage.write(key: 'auth_token', value: token);
      _token = token;
      notifyListeners();
    } catch (e) {
      print('Error setting token: $e');
      rethrow;
    }
  }

  Future<void> setRole(String role) async {
    try {
      await _storage.write(key: 'user_role', value: role);
      _role = role;
      notifyListeners();
    } catch (e) {
      print('Error setting role: $e');
      rethrow;
    }
  }

  // Clear token and role (logout)
  Future<void> logout() async {
    try {
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'user_role');
      await _storage.delete(key: 'user_id');
      _token = null;
      _role = null;
      _userId = null;
      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }

  // Store the token in SharedPreferences
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // Get the stored token
  static Future<String?> getToken() async {
    return instance.token;
  }

  // Get the stored user ID
  static Future<int?> getUserId() async {
    return instance.userId;
  }

  // Clear the stored token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  Future<Map<String, dynamic>> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
        ...?additionalHeaders,
      };

      http.Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
          'message': 'Request successful'
        };
      } else {
        Map<String, dynamic> errorData;
        try {
          errorData = jsonDecode(response.body);
        } catch (_) {
          errorData = {
            'message': 'Request failed with status ${response.statusCode}',
            'details': response.body
          };
        }
        return {
          'success': false,
          'message': errorData['message'] ?? 'Request failed',
          'details': errorData['details'] ?? response.body,
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred',
        'details': e.toString()
      };
    }
  }

  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin': origin,
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'fullName': username, // Using username as fullName for now
          'role': 'USER', // Default role
        }),
      );

      print('Registration response status: ${response.statusCode}');
      print('Registration response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await _saveToken(data['token']);
        }
        return {
          'success': true,
          'message': 'Registration successful',
          'data': data
        };
      } else {
        Map<String, dynamic> error;
        try {
          error = jsonDecode(response.body);
          print('Registration error response: $error');
        } catch (e) {
          print('Error parsing registration response: $e');
          error = {
            'message':
                'Registration failed: Server returned ${response.statusCode}',
            'details': response.body
          };
        }
        return {
          'success': false,
          'message':
              error['message'] ?? 'Registration failed: ${response.statusCode}',
          'details': error['details'] ?? response.body
        };
      }
    } catch (e) {
      print('Registration error: $e');
      return {
        'success': false,
        'message':
            'Network error occurred. Please check your connection and try again.',
        'details': e.toString()
      };
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _makeRequest(
      'POST',
      '/api/auth/login',
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response['success']) {
      final token = response['data']['token'];
      final role = response['data']['role'];
      await setToken(token);
      await setRole(role);
    }

    return response;
  }

  Future<bool> isAuthenticated() async {
    return _token != null;
  }

  // Helper method to get auth headers
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
      'Origin': origin,
    };
  }

  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token found'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Origin': origin,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'User data retrieved successfully'
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to get user data',
          'details': response.body
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error getting user data',
        'details': e.toString()
      };
    }
  }

  Future<void> setUserId(int userId) async {
    try {
      await _storage.write(key: 'user_id', value: userId.toString());
      _userId = userId;
      notifyListeners();
    } catch (e) {
      print('Error setting user ID: $e');
      rethrow;
    }
  }

  static Future<void> clearAuth() async {
    try {
      await instance._storage.delete(key: 'auth_token');
      await instance._storage.delete(key: 'user_role');
      await instance._storage.delete(key: 'user_id');
      instance._token = null;
      instance._role = null;
      instance._userId = null;
      instance.notifyListeners();
    } catch (e) {
      print('Error clearing auth: $e');
    }
  }

  Future<void> setAuth(String token, String role, int userId) async {
    try {
      await _storage.write(key: 'auth_token', value: token);
      await _storage.write(key: 'user_role', value: role);
      await _storage.write(key: 'user_id', value: userId.toString());
      _token = token;
      _role = role;
      _userId = userId;
      notifyListeners();
    } catch (e) {
      print('Error setting auth: $e');
    }
  }

  // Static methods for easy access
  static AuthService? _instance;

  static AuthService get instance {
    _instance ??= AuthService();
    return _instance!;
  }
}
