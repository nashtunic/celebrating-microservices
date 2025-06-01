import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AuthService.dart';
import '../models/user.dart';
import '../models/celebrity.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _role;
  dynamic _userData;
  final _authService = AuthService();

  String? get token => _token;
  String? get role => _role;
  dynamic get userData => _userData;

  Future<void> login(String username, String password) async {
    final result = await _authService.login(username, password);
    if (result['success']) {
      _token = await AuthService.getToken();
      if (_token == null) {
        print('Warning: No token received after login');
      }
      if (_role == null) {
        _role = await _loadRole();
      }
      _role = (result['data']?['role'] as String?)?.toUpperCase() ??
          _role ??
          'USER';
      print('Login: Updated role to $_role');

      if (result['data']?['user'] != null) {
        _userData = User(
          id: result['data']['user']['id'] as int,
          username: username,
          displayName:
              result['data']['user']['displayName'] as String? ?? username,
          email: result['data']['user']['email'] as String?,
          profileImage: result['data']['user']['profileImage'] as String?,
          createdAt:
              DateTime.parse(result['data']['user']['createdAt'] as String),
          followersCount: result['data']['user']['followersCount'] as int? ?? 0,
          followingCount: result['data']['user']['followingCount'] as int? ?? 0,
          isFollowing: false,
        );
      }
      notifyListeners();
    } else {
      throw Exception(result['message'] ?? 'Login failed');
    }
  }

  Future<void> register(
      String username, String email, String password, String role) async {
    final result = await _authService.register(username, email, password);
    if (result['success']) {
      _token = await AuthService.getToken();
      if (_token == null) {
        print('Warning: No token received after registration');
      }
      _role = role.toUpperCase();
      print('Register: Setting role to $_role');
      await _saveRole(_role!);

      if (_role == 'USER') {
        _userData = User(
          id: result['data']['id'] as int,
          username: username,
          displayName: username,
          email: email,
          createdAt: DateTime.now(),
          followersCount: 0,
          followingCount: 0,
          isFollowing: false,
        );
      } else {
        _userData = Celebrity(
          id: result['data']['id'] as int,
          username: username,
          displayName: username,
          stageName: username,
          fullName: username,
          dateOfBirth: '',
          placeOfBirth: '',
          nationality: '',
          ethnicity: '',
          netWorth: '',
          professions: [],
          debutWorks: [],
          majorAchievements: [],
          notableProjects: [],
          collaborations: [],
          agenciesOrLabels: [],
          stats: CelebrityStats(
            postsCount: 0,
            followersCount: 0,
            followingCount: 0,
          ),
        );
      }
      notifyListeners();
    } else {
      throw Exception(result['message'] ?? 'Registration failed');
    }
  }

  Future<void> loadToken() async {
    _token = await AuthService.getToken();
    if (_token != null) {
      _role = await _loadRole() ?? 'USER';
      print('LoadToken: Loaded role as $_role');
      _userData = User(
        id: 0,
        username: '',
        displayName: '',
        createdAt: DateTime.now(),
        followersCount: 0,
        followingCount: 0,
        isFollowing: false,
      );
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _token = null;
    _role = null;
    _userData = null;
    await _saveRole('');
    notifyListeners();
  }

  Future<void> _saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_role', role);
    print('SaveRole: Saved role as $role');

    final savedRole = prefs.getString('auth_role');
    if (savedRole != role) {
      print('Error: Role save failed. Expected $role, but got $savedRole');
    }
  }

  Future<String?> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('auth_role');
    print('LoadRole: Loaded role as $role');
    return role;
  }
}
