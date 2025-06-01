import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rating.dart';
import '../utils/constants.dart';
import '../AuthService.dart' as auth;
import '../config/api_config.dart';

class RatingService {
  final String baseUrl = ApiConfig.baseUrl;

  // Get ratings for a target
  Future<List<Rating>> getRatings({
    required String targetId,
    required String targetType,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final token = await auth.AuthService.getToken();
      final queryParams = {
        'targetId': targetId,
        'targetType': targetType,
        'page': page.toString(),
        'size': size.toString(),
      };

      final response = await http.get(
        Uri.parse('$baseUrl/api/ratings').replace(queryParameters: queryParams),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Rating.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load ratings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load ratings: $e');
    }
  }

  // Create a new rating
  Future<Rating> createRating({
    required String targetId,
    required String targetType,
    required int value,
    String? comment,
  }) async {
    try {
      final token = await auth.AuthService.getToken();

      final response = await http.post(
        Uri.parse('$baseUrl/api/ratings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'targetId': targetId,
          'targetType': targetType,
          'value': value,
          'comment': comment,
        }),
      );

      if (response.statusCode == 201) {
        return Rating.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create rating: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create rating: $e');
    }
  }

  // Update an existing rating
  Future<Rating> updateRating({
    required String ratingId,
    required int value,
    String? comment,
  }) async {
    try {
      final token = await auth.AuthService.getToken();

      final response = await http.put(
        Uri.parse('$baseUrl/api/ratings/$ratingId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'value': value,
          'comment': comment,
        }),
      );

      if (response.statusCode == 200) {
        return Rating.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update rating: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update rating: $e');
    }
  }

  // Delete a rating
  Future<void> deleteRating(String ratingId) async {
    try {
      final token = await auth.AuthService.getToken();

      final response = await http.delete(
        Uri.parse('$baseUrl/api/ratings/$ratingId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete rating: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete rating: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserPostRating(String postId) async {
    try {
      final token = await auth.AuthService.getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/api/ratings/posts/$postId/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get user rating');
      }
    } catch (e) {
      print('Error getting user rating: $e');
      return null;
    }
  }

  Future<void> ratePost(String postId, int rating) async {
    final token = await auth.AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.post(
      Uri.parse('$baseUrl/api/ratings/posts/$postId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'rating': rating}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to rate post');
    }
  }
}
