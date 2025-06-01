import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/celebrity.dart';
import '../models/post.dart';
import '../utils/constants.dart';
import 'auth_service.dart';

class SearchService {
  static const String baseUrl = ApiConstants.baseUrl;

  // Search users (both regular users and celebrities)
  Future<Map<String, dynamic>> searchAll(String query) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/search?q=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'users': (data['users'] as List)
              .map((json) => User.fromJson(json))
              .toList(),
          'celebrities': (data['celebrities'] as List)
              .map((json) => Celebrity.fromJson(json))
              .toList(),
          'posts': (data['posts'] as List)
              .map((json) => Post.fromJson(json))
              .toList(),
        };
      } else {
        throw Exception('Failed to search: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search: $e');
    }
  }

  // Search users only
  Future<List<User>> searchUsers(String query) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/users/search?q=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  // Search celebrities only
  Future<List<Celebrity>> searchCelebrities(String query) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/celebrities/search?q=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Celebrity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search celebrities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search celebrities: $e');
    }
  }

  // Search posts
  Future<List<Post>> searchPosts(String query) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/posts/search?q=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search posts: $e');
    }
  }
}
