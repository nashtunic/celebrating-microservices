import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/celebrity.dart';
import '../utils/constants.dart';
import '../services/auth_service.dart';

class CelebrityService {
  final String? authToken;

  CelebrityService({this.authToken});

  Future<List<Celebrity>> getAllCelebrities() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/users/celebrities'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Celebrity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load celebrities');
      }
    } catch (e) {
      throw Exception('Error fetching celebrities: $e');
    }
  }

  Future<List<Celebrity>> searchCelebrities(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}/api/users/celebrities/search?query=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Celebrity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search celebrities');
      }
    } catch (e) {
      throw Exception('Error searching celebrities: $e');
    }
  }

  Future<Celebrity> getCelebrityProfile(String userId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}/api/users/$userId/celebrity-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Celebrity.fromJson(data);
      } else {
        throw Exception('Failed to load celebrity profile');
      }
    } catch (e) {
      throw Exception('Error fetching celebrity profile: $e');
    }
  }

  Future<Celebrity> updateCelebrityProfile(
      String userId, Celebrity profile) async {
    try {
      final response = await http.put(
        Uri.parse(
            '${ApiConstants.baseUrl}/api/users/$userId/celebrity-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode(profile.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Celebrity.fromJson(data);
      } else {
        throw Exception('Failed to update celebrity profile');
      }
    } catch (e) {
      throw Exception('Error updating celebrity profile: $e');
    }
  }

  // Create a new celebrity profile
  Future<Celebrity> createCelebrity(Celebrity celebrity) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/celebrities'),
        headers: {
          'Content-Type': 'application/json',
          // Add authorization header if needed
          // 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(celebrity.toJson()),
      );

      if (response.statusCode == 201) {
        return Celebrity.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to create celebrity profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create celebrity profile: $e');
    }
  }

  // Update an existing celebrity profile
  Future<Celebrity> updateCelebrity(int id, Celebrity celebrity) async {
    try {
      final token = await AuthService.getToken();
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/api/celebrities/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(celebrity.toJson()),
      );

      if (response.statusCode == 200) {
        return Celebrity.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update celebrity: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update celebrity: $e');
    }
  }

  // Get celebrity profile by ID
  Future<Celebrity> getCelebrity(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/celebrities/$id'),
        headers: {
          // Add authorization header if needed
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return Celebrity.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to get celebrity profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get celebrity profile: $e');
    }
  }

  // Upload celebrity profile image
  Future<String> uploadProfileImage(int celebrityId, String imagePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseUrl}/api/celebrities/$celebrityId/image'),
      );

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imagePath,
      ));

      // Add authorization header if needed
      // request.headers['Authorization'] = 'Bearer $token';

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var data = jsonDecode(responseData);
        return data['imageUrl'];
      } else {
        throw Exception(
            'Failed to upload profile image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  // Get current user's celebrity profile
  Future<Map<String, dynamic>> getCurrentCelebrityProfile() async {
    try {
      final token = await AuthService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/celebrities/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to load celebrity profile',
          'error': response.body,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error loading celebrity profile',
        'error': e.toString(),
      };
    }
  }
}
