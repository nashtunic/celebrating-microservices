import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/celebrity.dart';
import '../models/feed_post.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080';

  Future<String> register(
      String username, String email, String password, String role) async {
    final payload = {
      'username': username,
      'email': email,
      'password': password,
      'fullName':
          username, // Assuming fullName is the same as username for simplicity
      'role': role.toUpperCase(),
    };
    print('Sending registration request with payload: $payload');
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    print(
        'Registration response status: ${response.statusCode}, body: ${response.body}');
    if (response.statusCode == 201) {
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final role = data['role'].toString().toLowerCase();
      return {
        'token': data['token'],
        'role': role,
        'userData': role == 'user'
            ? User.fromJson(data['user'])
            : Celebrity.fromJson(data['celebrity']),
      };
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<List<dynamic>> getPosts(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/posts'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)
          .map((json) => FeedPost.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load posts: ${response.body}');
    }
  }

  Future<void> createPost(String content, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/posts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({'content': content}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create post: ${response.body}');
    }
  }

  Future<void> deletePost(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/posts/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete post: ${response.body}');
    }
  }
}
