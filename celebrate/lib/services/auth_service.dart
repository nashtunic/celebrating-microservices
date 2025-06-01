import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class AuthService extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  String? _token;
  String? _role;
  String? _userId;

  String? get token => _token;
  String? get role => _role;
  String? get userId => _userId;

  // Initialize the service
  Future<void> init() async {
    _token = await storage.read(key: 'auth_token');
    _role = await storage.read(key: 'user_role');
    _userId = await storage.read(key: 'user_id');
    notifyListeners();
  }

  // Login method
  Future<bool> login(String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await setToken(data['token']);
        await setRole(data['role']);
        await setUserId(data['userId']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Set token and role
  Future<void> setToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
    _token = token;
    notifyListeners();
  }

  Future<void> setRole(String role) async {
    await storage.write(key: 'user_role', value: role);
    _role = role;
    notifyListeners();
  }

  Future<void> setUserId(String userId) async {
    await storage.write(key: 'user_id', value: userId);
    _userId = userId;
    notifyListeners();
  }

  // Clear token and role (logout)
  Future<void> logout() async {
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'user_role');
    await storage.delete(key: 'user_id');
    _token = null;
    _role = null;
    _userId = null;
    notifyListeners();
  }

  // Get token
  static Future<String?> getToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'auth_token');
  }

  // Get user ID
  static Future<String?> getUserId() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'user_id');
  }
}
