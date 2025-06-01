import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/news_feed_item.dart';
import '../utils/constants.dart';
import 'auth_service.dart';

class NewsFeedService {
  static const String baseUrl = ApiConstants.baseUrl;
  WebSocketChannel? _channel;
  Function(NewsFeedItem)? _onNewsFeedItemReceived;

  // Get news feed items with pagination
  Future<List<NewsFeedItem>> getNewsFeedItems({
    int page = 0,
    int size = 20,
    String? type,
    String? authorId,
    String? authorType, // 'regular' or 'celebrity'
  }) async {
    try {
      final token = await AuthService.getToken();
      final queryParams = {
        'page': page.toString(),
        'size': size.toString(),
        if (type != null) 'type': type,
        if (authorId != null) 'authorId': authorId,
        if (authorType != null) 'authorType': authorType,
      };

      final response = await http.get(
        Uri.parse('$baseUrl/api/news-feed')
            .replace(queryParameters: queryParams),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => NewsFeedItem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load news feed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load news feed: $e');
    }
  }

  // Get celebrity feed items
  Future<List<NewsFeedItem>> getCelebrityFeed({
    int page = 0,
    int size = 20,
    String? type,
  }) async {
    return getNewsFeedItems(
      page: page,
      size: size,
      type: type,
      authorType: 'celebrity',
    );
  }

  // Create a new news feed item
  Future<NewsFeedItem> createNewsFeedItem({
    required String title,
    required String content,
    required String type,
    List<String> mediaUrls = const [],
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.post(
        Uri.parse('$baseUrl/api/news-feed'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'content': content,
          'type': type,
          'mediaUrls': mediaUrls,
          'metadata': metadata,
        }),
      );

      if (response.statusCode == 201) {
        return NewsFeedItem.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to create news feed item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create news feed item: $e');
    }
  }

  // Like/unlike a news feed item
  Future<void> toggleLike(String itemId) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.post(
        Uri.parse('$baseUrl/api/news-feed/$itemId/toggle-like'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to toggle like: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }

  // Add a comment to a news feed item
  Future<void> addComment(String itemId, String comment) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.post(
        Uri.parse('$baseUrl/api/news-feed/$itemId/comments'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'content': comment}),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  // Connect to WebSocket for real-time updates
  void connectToWebSocket(Function(NewsFeedItem) onNewsFeedItemReceived) async {
    _onNewsFeedItemReceived = onNewsFeedItemReceived;
    final token = await AuthService.getToken();
    final wsUrl = baseUrl.replaceFirst('http', 'ws');

    _channel = WebSocketChannel.connect(
      Uri.parse('$wsUrl/ws/news-feed?token=$token'),
    );

    _channel!.stream.listen(
      (message) {
        final item = NewsFeedItem.fromJson(jsonDecode(message));
        _onNewsFeedItemReceived?.call(item);
      },
      onError: (error) {
        print('WebSocket error: $error');
        // Try to reconnect after a delay
        Future.delayed(const Duration(seconds: 5), () {
          connectToWebSocket(onNewsFeedItemReceived);
        });
      },
      onDone: () {
        print('WebSocket connection closed');
        // Try to reconnect after a delay
        Future.delayed(const Duration(seconds: 5), () {
          connectToWebSocket(onNewsFeedItemReceived);
        });
      },
    );
  }

  // Disconnect from WebSocket
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _onNewsFeedItemReceived = null;
  }
}
