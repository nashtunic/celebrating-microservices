import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/post.dart';
import '../utils/constants.dart';
import 'package:celebrate/AuthService.dart';

class PostService {
  static const String baseUrl = ApiConstants.baseUrl;
  WebSocketChannel? _channel;

  // Create a new post
  Future<Post> createPost({
    required String title,
    required String content,
    required String celebrationType,
    List<String> mediaUrls = const [],
    bool isPrivate = false,
  }) async {
    try {
      final token = await AuthService.getToken();
      final userId = await AuthService.getUserId();

      // If there are media URLs that are local paths, upload them first
      List<String> uploadedMediaUrls = [];
      for (String mediaUrl in mediaUrls) {
        if (mediaUrl.startsWith('file://') || !mediaUrl.startsWith('http')) {
          final uploadedUrl = await _uploadMedia(mediaUrl, token!);
          uploadedMediaUrls.add(uploadedUrl);
        } else {
          uploadedMediaUrls.add(mediaUrl);
        }
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/posts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-User-ID': userId.toString(),
        },
        body: jsonEncode({
          'title': title,
          'content': content,
          'celebrationType': celebrationType,
          'mediaUrls': uploadedMediaUrls,
          'isPrivate': isPrivate,
        }),
      );

      if (response.statusCode == 201) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  // Upload media for a post
  Future<String> _uploadMedia(String mediaPath, String token) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/posts/upload-media'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('media', mediaPath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['mediaUrl'];
      } else {
        throw Exception('Failed to upload media: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload media: $e');
    }
  }

  // Get user's posts
  Future<List<Post>> getUserPosts() async {
    try {
      final token = await AuthService.getToken();
      final userId = await AuthService.getUserId();

      final response = await http.get(
        Uri.parse('$baseUrl/api/posts/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get posts: $e');
    }
  }

  // Get recent posts
  Future<List<Post>> getRecentPosts() async {
    try {
      final token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/posts/recent'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get recent posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get recent posts: $e');
    }
  }

  // Delete a post
  Future<void> deletePost(int postId) async {
    try {
      final token = await AuthService.getToken();
      final userId = await AuthService.getUserId();

      final response = await http.delete(
        Uri.parse('$baseUrl/api/posts/$postId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-User-ID': userId.toString(),
        },
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  // Update a post
  Future<Post> updatePost(
    int postId, {
    String? title,
    String? content,
    String? celebrationType,
    List<String>? mediaUrls,
    bool? isPrivate,
  }) async {
    try {
      final token = await AuthService.getToken();
      final userId = await AuthService.getUserId();

      // If there are new media URLs that are local paths, upload them first
      List<String>? uploadedMediaUrls;
      if (mediaUrls != null) {
        uploadedMediaUrls = [];
        for (String mediaUrl in mediaUrls) {
          if (mediaUrl.startsWith('file://') || !mediaUrl.startsWith('http')) {
            final uploadedUrl = await _uploadMedia(mediaUrl, token!);
            uploadedMediaUrls.add(uploadedUrl);
          } else {
            uploadedMediaUrls.add(mediaUrl);
          }
        }
      }

      final Map<String, dynamic> updateData = {};
      if (title != null) updateData['title'] = title;
      if (content != null) updateData['content'] = content;
      if (celebrationType != null)
        updateData['celebrationType'] = celebrationType;
      if (uploadedMediaUrls != null)
        updateData['mediaUrls'] = uploadedMediaUrls;
      if (isPrivate != null) updateData['isPrivate'] = isPrivate;

      final response = await http.put(
        Uri.parse('$baseUrl/api/posts/$postId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-User-ID': userId.toString(),
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  // Connect to WebSocket for real-time updates
  void connectToWebSocket(Function(Post) onPostReceived) async {
    final token = await AuthService.getToken();
    final wsUrl = baseUrl.replaceFirst('http', 'ws');

    _channel = WebSocketChannel.connect(
      Uri.parse('$wsUrl/ws/posts?token=$token'),
    );

    _channel!.stream.listen(
      (message) {
        final post = Post.fromJson(jsonDecode(message));
        onPostReceived(post);
      },
      onError: (error) {
        print('WebSocket error: $error');
        // Try to reconnect after a delay
        Future.delayed(const Duration(seconds: 5), () {
          connectToWebSocket(onPostReceived);
        });
      },
      onDone: () {
        print('WebSocket connection closed');
        // Try to reconnect after a delay
        Future.delayed(const Duration(seconds: 5), () {
          connectToWebSocket(onPostReceived);
        });
      },
    );
  }

  // Disconnect from WebSocket
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  // Get posts by hashtag
  Future<List<Post>> getPostsByHashtag(String hashtag) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/posts/hashtag/$hashtag'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get posts: $e');
    }
  }
}
